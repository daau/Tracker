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


final class Store: ObservableObject {
    static let shared = Store()
    
    var eventStore = EKEventStore()
    var reminders: [EKReminder] = []
    var calendars: [EKCalendar] = []
    var defaultCalendar: EKCalendar
    
    init() {
        defaultCalendar = eventStore.calendars(for: .reminder)[0]
        requestAccess()
    }
    
//    Only for prototyping
    init(withStore store: EKEventStore) {
        defaultCalendar = eventStore.calendars(for: .reminder)[0]
        eventStore = store
    }
    
    func save(reminder: EKReminder) {
        do {
            try eventStore.save(reminder, commit: true)
        } catch {
            print("Error saving reminder \(error)")
        }
    }
    
    
    func add(reminder: EKReminder) {
        reminder.calendar = eventStore.calendars(for: .reminder)[0]
        
        do {
            try eventStore.save(reminder, commit: true)
            reminders.append(reminder)
        } catch {
            print(eventStore.calendars(for: .reminder))
            print("Error saving reminder: \(error)")
        }
    }
    
    func remove(_ reminder: EKReminder) {
        self.reminders.removeAll { e in
            e == reminder
        }
    }
    
    func remove(at index: Int) {
        let reminderToDelete = reminders[index]
        do {
            try eventStore.remove(reminderToDelete, commit: true)
            reminders.remove(at: index)
        } catch {
            print("Error removing reminder: \(error)")
        }
    }
    
    func deleteAll() {
        print("Store deleting everything")
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
        
        load()
    }
    
    func getReminders(for ekCalendar: EKCalendar) -> [EKReminder] {
        let fetchAllPredicate = self.eventStore.predicateForReminders(in: [ekCalendar])
        var res: [EKReminder] = []
        print("first")
        self.eventStore.fetchReminders(matching: fetchAllPredicate) { fetchResult in
            res = fetchResult ?? []
            print("second")
        }
        
        print("third")
        return res
    }
    
    private func load() {
        let fetchAllPredicate = self.eventStore.predicateForReminders(in: nil)
        
        self.eventStore.fetchReminders(matching: fetchAllPredicate) { fetchResult in
            self.reminders = fetchResult ?? []
        }
        
        self.calendars = self.eventStore.calendars(for: .reminder)
        
        // get reminders for each calendar
        
    }
    
    private func requestAccess() {
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted {
                print("loading")
                self.load()
            } else {
                print("requestAccess - DENIED")
            }
        }
    }
}

// MARK: Prototyping related code
// All code related to previews and rapid prototyping here
extension Store {
    static var preview: Store {
        get {
            let faker = Faker(locale: "nb-NO")
            
            let mockStore = EKEventStore()
            let mockCalendar = EKCalendar(for: .reminder, eventStore: mockStore)
            let mockSelf = Store(withStore: mockStore)
            
            for _ in 1...3 {
                let mockReminder = EKReminder(eventStore: mockStore)
                
                mockReminder.title = faker.lorem.sentences(amount: 1)
                mockReminder.calendar = mockCalendar
                
                mockSelf.reminders.append(mockReminder)
            }
            return mockSelf
        }
    }
    
    func addFakeReminder(calendar: EKCalendar) -> EKReminder {
        let faker = Faker(locale: "nb-NO")
        let mockEKReminder = EKReminder(eventStore: eventStore)
//        let calendar = eventStore.calendars(for: .reminder)[0]
        
        mockEKReminder.title = faker.lorem.sentences(amount: 1)
        mockEKReminder.calendar = calendar
        reminders.append(mockEKReminder)
        
        do {
            try eventStore.save(mockEKReminder, commit: true)
        } catch {
            print("Error creating mock event: \(error)")
        }
        
        return mockEKReminder
    }
}
