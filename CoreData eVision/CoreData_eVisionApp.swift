//
//  CoreData_eVisionApp.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

//@main
//struct CoreData_eVisionApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}

import SwiftUI
import BackgroundTasks
import CoreData
import UserNotifications

@main
struct CoreData_eVisionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @AppStorage("isDarkMode") private var isDarkModeOn = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
        }
    }

    init() {
        appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil, persistentContainer: persistenceController.container)
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    var persistentContainer: NSPersistentContainer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?, persistentContainer: NSPersistentContainer) -> Bool {
        
        self.persistentContainer = persistentContainer
        // Richiedi il permesso per le notifiche
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error)")
            }
        }

        // Registra le attività in background
        registerBackgroundTask()
        return true
    }


    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.yourapp.checkFreeRooms", using: nil) { task in
            self.handleCheckFreeRooms(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleCheckFreeRooms() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.myApp.checkFreeRooms")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 10) // 10 minuti
        print("Miao")

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule check free rooms: \(error)")
        }
    }

    func handleCheckFreeRooms(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        print("Checking Free rooms")
        // Esegui il controllo delle aule libere e invia le notifiche
        checkFreeRoomsAndSendNotification { success in
            task.setTaskCompleted(success: success)
            self.scheduleCheckFreeRooms()
        }
    }

    func checkFreeRoomsAndSendNotification(completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.newBackgroundContext()

        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPreferred == YES")
        
        context.perform {
            do {
                let preferredBuildings = try context.fetch(fetchRequest)

                for building in preferredBuildings {
                    var freeRooms: [String] = []
                    var shouldSendNotification = false

                    for room in building.getRooms {
                        let isFreeNow = room.isFreeNow()
                        if isFreeNow != room.wasFree {
                            shouldSendNotification = true
                        }
                        if isFreeNow {
                            freeRooms.append(room.getName)
                            room.updateFreeStatus()
                        }
                    }

                    if shouldSendNotification {
                        self.sendNotification(with: building, and: freeRooms)
                    }
                }

                try context.save()
                completion(true)
            } catch {
                print("Error fetching preferred buildings: \(error)")
                completion(false)
            }
        }
    }

    func sendNotification(with building: Building, and freeRooms: [String]) {
        let content = UNMutableNotificationContent()
        content.title = "Free rooms in \(building.getName)"
        content.body = "The following rooms are currently free: \(freeRooms.joined(separator: ", "))"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }


}

