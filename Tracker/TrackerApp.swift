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
    @StateObject var eventFetcher = Store.shared

    var body: some Scene {
        WindowGroup {
            CategoryView()
                .environmentObject(eventFetcher)

        }
    }
}
