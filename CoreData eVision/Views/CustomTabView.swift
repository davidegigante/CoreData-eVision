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
                withAnimation {
                    selectedTab = .home
                }
            } label: {
                VStack {
                    Image(systemName: "house")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(.top)
                    Text("Home")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .home ? .blue : .primary)
            }
            .buttonStyle(TabButtonStyle())
            Spacer()
            Button {
                withAnimation {
                    selectedTab = .camera
                }
            } label: {
                VStack {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(.top)
                    Text("Scan")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .camera ? .blue : .primary)
            }
            .buttonStyle(TabButtonStyle())
            Spacer()
            Button {
                withAnimation {
                    selectedTab = .settings
                }
            } label: {
                VStack {
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(.top)
                    Text("Settings")
                        .font(.caption2)
                }
                .foregroundColor(selectedTab == .settings ? .blue : .primary)
            }
            Spacer()
        }
        .background(.thinMaterial)
    }
}

enum Tab {
    case home
    case camera
    case settings
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

