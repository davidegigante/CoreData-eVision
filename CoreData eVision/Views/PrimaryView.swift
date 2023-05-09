//
//  PrimaryView.swift
//  UniSa eVision
//
//  Created by Davide Gigante
//

import SwiftUI

struct PrimaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTab: Tab = .home
    @State private var showingImagePicker = false
    @State private var showAlert = false
    @State private var recognizedText: String?
    
    @FetchRequest(entity: Building.entity(), sortDescriptors: []) var buildings: FetchedResults<Building>
    
    var body: some View {
        VStack {
            switch selectedTab {
            case .home:
                withAnimation {
                    NavigationView {
                        HomeView()
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
            case .camera:
                NavigationView() {
                    VStack{}
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                }
                .onAppear {
                    showingImagePicker = true
                }
            case .settings:
                withAnimation {
                    NavigationView() {
                        SettingsView()
                    }
                }
            }
            CustomTabView(selectedTab: $selectedTab, showingCameraSheet: $showingImagePicker)
                .frame(height: 25)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: { withAnimation(Animation.easeInOut.speed(2.5)) { selectedTab = .home }}) {

            ImagePicker(sourceType: .camera) { image in
                ImagePicker.recognizeText(from: image) { text in
                    if text.isEmpty {
                        showAlert = true
                    } else {
                        recognizedText = text
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Nessun testo riconosciuto"), message: Text("Non è stato possibile riconoscere il testo nella foto. Riprova."), dismissButton: .default(Text("OK")))
        }
    }
    
}


