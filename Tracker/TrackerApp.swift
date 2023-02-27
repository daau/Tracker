//
//  TrackerApp.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-16.
//

import SwiftUI
import GoogleSignIn

@main
struct TrackerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var eventFetcher = EventFetcher.shared

    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environmentObject(eventFetcher)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
