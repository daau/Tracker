//
//  CategoryView.swift
//  Tracker
//
//  Created by Daniel Au on 2023-03-02.
//

import SwiftUI

struct CategoryView: View {
    @StateObject var viewModel = ViewModel(store: Store.shared)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.calendars) { $calendar in
                    NavigationLink(calendar.title, destination: TodoListView(calendar: $calendar, viewModel: viewModel))
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
