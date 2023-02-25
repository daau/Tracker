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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        if (user != nil) {
                            print("User exists")
                        } else {
                            if let validError = error {
                                print(validError)
                                print(validError.localizedDescription)
                            }
                        }
                    }
                }
        }
    }
}
