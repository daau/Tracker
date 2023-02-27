//
//  EventFetcher.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-24.
//

import Foundation
import EventKit
import Combine
import Fakery

class Test: ObservableObject {
    @Published var title: String = ""
}

final class EventFetcher: ObservableObject {
    static let shared = EventFetcher()
    
    var eventStore = EKEventStore()
    var test = Test()
    @Published var reminders: [EKReminder] = []
    
    init() {
        requestAccess()
        print(eventStore.calendars(for: .reminder))
    }
    
//    Only for prototyping
    init(withStore store: EKEventStore) {
        eventStore = store
    }
    
    
    func addReminder(text: String) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = text
        reminder.calendar = eventStore.calendars(for: .reminder)[0]
        
        do {
            try eventStore.save(reminder, commit: true)
            reminders.append(reminder)
        } catch {
            print(eventStore.calendars(for: .reminder))
            print("Error saving reminder: \(error)")
        }
    }
    
    func remove(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let reminderToDelete = reminders[index]
            do {
                try eventStore.remove(reminderToDelete, commit: true)
                reminders.remove(atOffsets: indexSet)
            } catch {
                print("Error removing reminder: \(error)")
            }
        }
    }
    
    func removeAll() {
        for reminder in reminders {
            do {
                try eventStore.remove(reminder, commit: false)
            } catch {
                print("Error removing single reminder: \(error)")
            }
        }
        
        do {
            try eventStore.commit()
        } catch {
            print("Error commiting removal: \(error)")
        }
        
        loadReminders()
    }
    
    private func loadReminders() {
        let fetchAllPredicate = self.eventStore.predicateForReminders(in: nil)
        
        self.eventStore.fetchReminders(matching: fetchAllPredicate) { fetchResult in
            DispatchQueue.main.async {
                self.reminders = fetchResult ?? []
            }
        }
    }
    
    private func updateReminders() {
        
    }
    
    private func requestAccess() {
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                self.loadReminders()
            } else {
                print("requestAccess - DENIED")
            }
        }
    }
}

// MARK: Prototyping related code
// All code related to previews and rapid prototyping here
extension EventFetcher {
    static var preview: EventFetcher {
        get {
            let faker = Faker(locale: "nb-NO")
            let mockEKEventStore = EKEventStore()
            let mockSelf = EventFetcher(withStore: mockEKEventStore)
            
            for _ in 1...3 {
                let mockEKReminder = EKReminder(eventStore: mockEKEventStore)
                mockEKReminder.title = faker.lorem.sentences(amount: 1)
                
                mockSelf.reminders.append(mockEKReminder)
            }
            return mockSelf
        }
    }
    
    func addFakeReminder() {
        let faker = Faker(locale: "nb-NO")
        let mockEKReminder = EKReminder(eventStore: eventStore)
        let calendar = eventStore.calendars(for: .reminder)[0]
        
        mockEKReminder.title = faker.lorem.sentences(amount: 1)
        mockEKReminder.calendar = calendar
        reminders.append(mockEKReminder)
        
        do {
            try eventStore.save(mockEKReminder, commit: true)
        } catch {
            print("Error creating mock event: \(error)")
        }
    }
}
