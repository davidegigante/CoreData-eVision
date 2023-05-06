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
    
    // Custom comparison function
    func compareBuildingNames(_ a: String, _ b: String) -> ComparisonResult {
        if a.count == 1 && b.count == 1 {
            if a > b {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        } else if a.first! == b.first! {
            if a.count > b.count {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        } else {
            if a.first! > b.first! {
                return .orderedDescending
            } else {
                return .orderedAscending
            }
        }
    }
    
    @FetchRequest(entity: Building.entity(), sortDescriptors: []) var buildings: FetchedResults<Building>
    
    var sortedBuildings: [Building] {
            return buildings.sorted()
        }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if sortedBuildings.filter({ $0.isPreferred }).count == 0 {
                            OopsCard()
                        } else {
                            ForEach(sortedBuildings.filter({ $0.isPreferred }), id: \.self) { building in
                                NavigationLink(destination: BuildingView(building: building).environment(\.managedObjectContext, viewContext)) {
                                    BuildingCard(building: building)
                                }
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
                    ForEach(self.sortedBuildings, id: \.self) { building in
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

