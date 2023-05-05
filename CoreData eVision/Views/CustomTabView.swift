//
//  CustomTabView.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 05/05/23.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    @Binding var showingCameraSheet: Bool // aggiungi questo binding
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                selectedTab = .first
            } label: {
                VStack {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Home")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .first ? .blue : .primary)
            }
            .buttonStyle(TabButtonStyle())
            Spacer()
            Button {
                showingCameraSheet = true // imposti lo stato a true al click del pulsante
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color("CardBackground"))
                        .frame(width: 80, height: 80)
                        .shadow(radius: 2)
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 72, height: 72)
                }
            }
            .offset(y: -40)
            Spacer()
            Button {
                selectedTab = .second
            } label: {
                VStack {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text("Settings")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .second ? .blue : .primary)
            }
            Spacer()
        }
        .background(.thinMaterial)
    }
}

enum Tab {
    case first
    case second
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

