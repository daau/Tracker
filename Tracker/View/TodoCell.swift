//
//  TodoCell.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-26.
//

import SwiftUI
import EventKit

struct TodoCell: View {
    @Binding var reminder: Reminder
    @ObservedObject var vm: ViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack{
            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(reminder.isCompleted ? .green : .gray)
                .font(.title3)
                .onTapGesture {
                    print("Reminder tapped")
                    reminder.isCompleted.toggle()
                    vm.commit(reminder)
                }
            TextField("Enter a reminder", text: $reminder.title)
                .focused($isFocused)
                .onChange(of: isFocused) { isFocused in
                    if (!isFocused) {
                        print("commit")
                        vm.commit(reminder)
                    }
                }
        }
    }
}

//struct TodoCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoCell(reminder: .constant(Reminder(isCompleted: false, title: "my Reminder")))
//    }
//}
