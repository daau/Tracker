//
//  EKReminder+Extensions.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-25.
//

import Foundation
import EventKit

extension EKReminder: Identifiable {
    public var id: String {
        return self.calendarItemExternalIdentifier
    }
}
