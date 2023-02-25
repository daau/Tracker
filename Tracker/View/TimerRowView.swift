//
//  TimerRowView.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-16.
//

import SwiftUI

struct TimerRowView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            HStack {
                CircleProgressView(progress: 0.8)
                    .padding()
                Text("Hello World")
                    .font(.system(.title))
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100)
        .padding()
    }
}

struct TimerRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimerRowView()
    }
}
