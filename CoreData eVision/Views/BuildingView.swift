//
//  BuildingView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI

struct BuildingView: View {
    @ObservedObject var building: Building
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                Text("Actually free rooms")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity), spacing: 30)], spacing: 20) {
                    ForEach(building.getRooms.filter({ $0.isFreeNow()})) { room in
                        NavigationLink(destination: RoomView(room: room)) {
                            RoomCard(room: room)
                        }
                    }
                }
                Text("All available rooms")
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .infinity), spacing: 30)], spacing: 20) {
                    ForEach(building.getRooms) { room in
                        NavigationLink(destination: RoomView(room: room)) {
                            RoomCard(room: room)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Building \(building.getName)")
            .toolbar {
                ToolbarItem {
                    CustomButton(systemImage: "suit.heart.fill", status: building.isPreferred, activeTint: .pink, inActiveTint: .gray) {
                        building.isPreferred.toggle()
                        do {
                            try viewContext.save()
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                        print("Is \(building.getName) preferred? \(building.isPreferred)")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .foregroundColor(status ? activeTint : inActiveTint)
            
        }
    }
}





