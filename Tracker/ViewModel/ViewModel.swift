//
//  TodoCellViewModel.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-28.
//

import Foundation
import EventKit

struct Reminder: Identifiable, Hashable {
    var id = UUID()
    var isCompleted: Bool
    var title: String
    
    var ek: EKReminder
}

class Calendar: Identifiable {
    var id: UUID
    var title: String
    var reminders: [Reminder]
    var ekCal: EKCalendar
    
    init(title: String, ekCal: EKCalendar) {
        self.id = UUID()
        self.title = title
        self.ekCal = ekCal
        self.reminders = []
    }
}

class ViewModel: ObservableObject {
    var store: Store!
    @Published var reminders: [Reminder] = []
    @Published var calendars: [Calendar] = []
    
    init(store: Store) {
        self.store = store
        
        for ekCal in store.calendars {
            var calendar = Calendar(title: ekCal.title, ekCal: ekCal)
            calendars.append(calendar)
        }
        
        for ekReminder in store.reminders {
            var reminder = Reminder(isCompleted: ekReminder.isCompleted, title: ekReminder.title, ek: ekReminder)
            reminders.append(reminder)
            
            var linkedCalendar = self.calendars.first { calendar in
                calendar.ekCal == reminder.ek.calendar
            }
            
            if (linkedCalendar != nil) {
                linkedCalendar!.reminders.append(Reminder(isCompleted: ekReminder.isCompleted, title: ekReminder.title, ek: ekReminder))
            }
        }
        
        print(calendars[0].reminders)
    }
    
    func commit(_ reminder: Reminder) {
        reminder.ek.title = reminder.title
        reminder.ek.isCompleted = reminder.isCompleted
        
        store.save(reminder: reminder.ek)
    }
    
    func deleteAll() {
        store.deleteAll()
        self.reminders = []
    }
    
    func remove(at indexSet: IndexSet, calendar: Calendar) {
        
        indexSet.forEach { index in
            let reminder = calendar.reminders[index]
            
            calendar.reminders.remove(at: index)
            let deleteIndex = self.reminders.firstIndex { r in
                r.id == reminder.id
            }
            self.reminders.remove(at: deleteIndex!)
            
            store.remove(at: deleteIndex!)
        }
    }
    
    func add(text: String) {
        let ek = EKReminder(eventStore: store.eventStore)
        ek.title = text
        ek.calendar = store.defaultCalendar
        
        store.add(reminder: ek)
    }
    
    func addFakeReminder(for calendar: Calendar) {
        let mockEkr = store.addFakeReminder(calendar: calendar.ekCal)
        let reminder = Reminder(isCompleted: mockEkr.isCompleted, title: mockEkr.title, ek: mockEkr)
        
        calendar.reminders.append(reminder)
        reminders.append(reminder)
    }
    
    
    func toEKReminder(_ reminder: Reminder) -> EKReminder {
        let ekReminder = EKReminder(eventStore: self.store.eventStore)
        ekReminder.title = reminder.title
        ekReminder.isCompleted = reminder.isCompleted
        
        return ekReminder
    }
}
