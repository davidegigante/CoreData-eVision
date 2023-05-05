//
//  HomeView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab: Tab = .first
    @State private var showingCameraSheet = false 
    @State private var recognizedText: String?
    
    @FetchRequest(entity: Building.entity(), sortDescriptors: []) var buildings: FetchedResults<Building>
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if self.buildings.filter({ $0.isPreferred }).count == 0 {
                            // mostra la card "No one yet!" ...
                        }
                        ForEach(self.buildings.filter({ $0.isPreferred }), id: \.self) { building in
                            NavigationLink(destination: BuildingView(building: building).environment(\.managedObjectContext, viewContext)) {
                                BuildingCard(building: building)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Preferred buildings")
                
                Text("University")
                    .font(.title).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 30)], spacing: 30) {
                    ForEach(self.buildings, id: \.self) { building in
                        NavigationLink(destination: BuildingView(building: building)
                            .environment(\.managedObjectContext, viewContext)) {
                            SmallBuildingCard(building: building)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

