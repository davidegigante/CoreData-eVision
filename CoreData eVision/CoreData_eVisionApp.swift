//
//  CoreData_eVisionApp.swift
//  CoreData eVision
//
//  Created by Davide Gigante on 02/05/23.
//

import SwiftUI
@main
struct CoreData_eVisionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
