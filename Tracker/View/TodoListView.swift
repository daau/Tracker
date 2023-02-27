//
//  TodoListView.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-25.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var eventFetcher: EventFetcher
    @State var textFieldText: String = ""
    @State var isEditingTodo: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(eventFetcher.reminders) { reminder in
                    Text("\(reminder.title)")
                }.onDelete { indexSet in
                    eventFetcher.remove(at: indexSet)
                }
                if isEditingTodo {
                    TextField("New Todo", text: $textFieldText)
                        .onSubmit {
                            addItem()
                        }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        eventFetcher.removeAll()
                    } label: {
                        Label("Delete everything", systemImage: "arrow.clockwise")
                    }

                }
                ToolbarItem {
                    Button(action: addMockItem) {
                        Label("Add Fake Todo", systemImage: "doc.badge.plus")
                    }
                }
                ToolbarItem {
                    Button {
                        isEditingTodo = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addItem() {
        eventFetcher.addReminder(text: textFieldText)
        
        textFieldText = ""
        isEditingTodo = false
    }
    
    private func addMockItem() {
        eventFetcher.addFakeReminder()
    }
}

struct TodoListView_Previews: PreviewProvider {
    static let eventFetcher = EventFetcher.preview
    static var previews: some View {
        TodoListView(isEditingTodo: false)
            .environmentObject(eventFetcher)
    }
}
