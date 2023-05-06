//
//  ContentView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isLoading = true

    var body: some View {
        if self.isLoading {
            LoadingView()
                .onAppear {
                    let setupCompleted = UserDefaults.standard.bool(forKey: "setupCompleted")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        checkSetup(setupCompleted)
                    }
                }
        } else {
            PrimaryView()
                .transition(.opacity)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    func setup(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://easycourse.unisa.it/AgendaStudenti//rooms_call.php")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            context.perform {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let areaRooms = (json as? [String: Any])?["area_rooms"] as? [String: [String: [String: Any]]] {
                        for (buildingCode, rooms) in areaRooms {
                            if let buildingName = rooms.values.first?["area"] as? String,
                               let extractedBuildingName = buildingName.extractName() {
                                
                                let building = NSEntityDescription.insertNewObject(forEntityName: "Building", into: context) as! Building
                                building.name = extractedBuildingName
                                building.code = buildingCode
                                
                                for (_, roomData) in rooms {
                                    if let roomName = roomData["room_name"] as? String,
                                       let roomId = roomData["room_code"] as? String {
                                        let room = NSEntityDescription.insertNewObject(forEntityName: "Room", into: context) as! Room
                                        room.name = roomName
                                        room.id = roomId
                                        room.building = building
                                    }
                                }
                            }
                        }
                        
                        try context.save()
                        UserDefaults.standard.set(true, forKey: "setupCompleted")
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    func getEventsForBuilding(_ building: Building, context: NSManagedObjectContext, completion: @escaping (Bool, String) -> Void) {
        let url = URL(string: "https://easycourse.unisa.it/AgendaStudenti//rooms_call.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "sede=\(building.getCode)&date=\(Date.getCurrentDateFormatted())"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                completion(false, "Errore: \(error?.localizedDescription ?? "Response error")")
                return
            }
            
            if (200...299).contains(response.statusCode)  {
                context.perform {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let events = json["events"] as? [[String: Any]] {
                                for event in events {
                                    if let roomName = event["NomeAula"] as? String,
                                       let lectureName = event["nome"] as? String,
                                       let from = event["from"] as? String,
                                       let to = event["to"] as? String,
                                       let type = event["type"] as? String,
                                       let professorsData = event["Utenti"] as? [[String: Any]] {
                                        
                                        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
                                        fetchRequest.predicate = NSPredicate(format: "name == %@ AND building == %@", roomName, building)
                                        
                                        guard let room = try context.fetch(fetchRequest).first else {
                                            completion(false, "No room found in \(building.getName)!!!!")
                                            return
                                        }
                                        
                                        let lecture = Lecture(context: context)
                                        lecture.name = lectureName
                                        lecture.from = Date.stringToTime(from)
                                        lecture.to = Date.stringToTime(to)
                                        lecture.type = type
                                        lecture.room = room
                                        
                                        for professorData in professorsData {
                                            if let firstName = professorData["Nome"] as? String,
                                               let lastName = professorData["Cognome"] as? String,
                                               let email = professorData["Mail"] as? String {
                                                let professor = Professor(context: context)
                                                professor.name = firstName
                                                professor.surname = lastName
                                                professor.mail = email
                                                professor.lecture = lecture
                                                lecture.addToProfessors(professor)
                                            }
                                        }
                                        
                                        room.addToLectures(lecture)
                                    } else {
                                        completion(false, "Error parsing JSON response")
                                    }
                                }
                                try context.save()
                                completion(true, "Success, \(building.getName)")
                            }
                        }
                    } catch {
                        completion(false, "Error parsing JSON response: \(error)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func getAllEvents(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        
        do {
            let buildings = try context.fetch(fetchRequest)
            let totalBuildings = buildings.count
            var completedBuildings = 0
            
            for building in buildings {
                let rooms = building.getRooms
                rooms.forEach { room in
                    room.clearLecturesAndProfessors(context: context)
                }
                
                getEventsForBuilding(building, context: context) { success, value in
                    if success {
                        completedBuildings += 1
                    } else {
                        print("Issue with \(building.getName)!")
                        completion(false)
                    }
                    
                    if completedBuildings == totalBuildings {
                        completion(true)
                    }
                }
            }
            UserDefaults.standard.set(Date.getCurrentDateFormatted(), forKey: "currentDateFormatted")
        } catch {
            print("Error fetching buildings: \(error)")
            completion(false)
        }
    }
    
    fileprivate func checkSetup(_ setupCompleted: Bool) {
        if !setupCompleted {
            setup(context: viewContext) { success in
                if success {
                    print("Setup successfully completed!")
                    getAllEvents(context: viewContext) { result in
                        print("Upload completed? \(result)")
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                } else {
                    print("Sorry! Unisa eVision had an issue with fetching data!")
                }
            }
        } else {
            print("Setup already done!")
            removeDuplicateBuildings(context: viewContext)
            if let savedDateFormatted = UserDefaults.standard.string(forKey: "currentDateFormatted") {
                print("Saved date formatted: \(savedDateFormatted)")
                print("Current date formatted: \(Date.getCurrentDateFormatted())")
                if savedDateFormatted != Date.getCurrentDateFormatted() {
                    getAllEvents(context: viewContext) { result in
                        print("Upload completed? \(result)")
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                } else {
                    withAnimation {
                        self.isLoading = false
                    }
                }
            } else {
                setup(context: viewContext) { success in
                    if success {
                        print("Setup successfully completed but already done!")
                        getAllEvents(context: viewContext) { result in
                            print("Upload completed? \(result)")
                            withAnimation {
                                self.isLoading = false
                            }
                        }
                    } else {
                        print("Sorry! Unisa eVision had an issue with fetching data!")
                    }
                }
            }
        }
    }
    
    func removeDuplicateBuildings(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        print("I'm checking for equal buildings!!")

        do {
            let buildings = try context.fetch(fetchRequest)

            // Crea un dizionario per tenere traccia del conteggio delle aule per ciascun edificio
            var buildingCounts: [String: (building: Building, count: Int)] = [:]

            // Conta il numero di aule per ciascun edificio
            for building in buildings {
                let buildingName = building.name ?? ""
                let roomCount = building.rooms?.count ?? 0

                // Se l'edificio è già nel dizionario, confronta il conteggio delle aule e tieni quello con più aule
                if let existing = buildingCounts[buildingName], existing.count < roomCount {
                    buildingCounts[buildingName] = (building, roomCount)
                } else if buildingCounts[buildingName] == nil {
                    buildingCounts[buildingName] = (building, roomCount)
                }
            }

            // Rimuovi gli edifici duplicati
            for building in buildings {
                let buildingName = building.name ?? ""
                if let existing = buildingCounts[buildingName], existing.building != building {
                    context.delete(building)
                }
            }

            try context.save()
        } catch {
            print("Error fetching buildings: \(error)")
        }
    }
    
}
