//
//  TodoListView.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-25.
//

import SwiftUI

struct TodoListView: View {
    @Binding var calendar: Calendar
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                    ForEach($calendar.reminders) { $reminder in
                        TodoCell(reminder: $reminder, vm: viewModel)
                    }
                    .onDelete { indexSet in
                        viewModel.remove(at: indexSet, calendar: calendar)
                    }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.deleteAll()
                        print("Delete everything")
                    } label: {
                        Label("Delete everything", systemImage: "arrow.clockwise")
                    }

                }
                ToolbarItem {
                    Button {
                        addFakeReminder(for: calendar)
                        print("mockTodo")
                    } label: {
                        Label("Add Fake Todo", systemImage: "doc.badge.plus")
                    }
                }
                ToolbarItem {
                    Button {
                        print("add item")
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
    }
    
    private func addFakeReminder(for calendar: Calendar) {
        viewModel.addFakeReminder(for: calendar)
    }
}

//struct TodoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoListView()
//    }
//}
