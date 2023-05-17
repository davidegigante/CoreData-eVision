//
//  PrimaryView.swift
//  UniSa eVision
//
//  Created by Davide Gigante
//

import SwiftUI
import CoreData

struct PrimaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab: Tab = .home
    @State private var showingImagePicker = false
    @State private var showAlert = false
    @State private var recognizedText: String?
    @State private var matchingBuilding: Building?
    
    @FetchRequest(entity: Building.entity(), sortDescriptors: []) var buildings: FetchedResults<Building>
    
    @ViewBuilder
    var contentView: some View {
        switch selectedTab {
        case .home:
            HomeView().environment(\.managedObjectContext, viewContext)
        case .camera:
            Group {
                if let building = matchingBuilding {
                    BuildingView(building: building)
                } else {
                    VStack {}
                        .background()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .onAppear {
                showingImagePicker = true
            }
            .onDisappear {
                recognizedText = nil
            }
        case .settings:
            SettingsView()
        }
    }

    var body: some View {
        VStack {
            NavigationView {
                contentView
            }
            .navigationViewStyle(StackNavigationViewStyle())

            CustomTabView(selectedTab: $selectedTab, showingCameraSheet: $showingImagePicker)
                .frame(height: 25)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: { withAnimation(Animation.easeInOut.speed(2.5)) {
            if recognizedText == nil {
                selectedTab = .home }
        } }) {
            ImagePicker(sourceType: .camera) { image in
                ImagePicker.recognizeText(from: image) { text in
                    if text.isEmpty {
                        showAlert = true
                    } else {
                        recognizedText = text
                        matchingBuilding = findBuilding(withName: text)
                        if matchingBuilding == nil {
                            showAlert = true
                            withAnimation {
                                selectedTab = .home
                            }
                        }
                    }
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("No building recognized"), message: Text("It was not possible to recognize the building in the photo. Please try again."), dismissButton: .default(Text("OK")))
        }
    }
    
    func findBuilding(withName name: String) -> Building? {
        let fetchRequest: NSFetchRequest<Building> = Building.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching building with name: \(name), error: \(error.localizedDescription)")
            return nil
        }
    }
}


