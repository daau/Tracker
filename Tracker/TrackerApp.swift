//
//  TrackerApp.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-16.
//

import SwiftUI

@main
struct TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
