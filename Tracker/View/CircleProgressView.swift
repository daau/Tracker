//
//  CircleProgressView.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-16.
//

import SwiftUI

struct CircleProgressView: View {
    var progress: Double
    var color = Color.white
    var opacity = 0.2
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .foregroundColor(color.opacity(opacity))
            Circle()
                .trim(from: 0.0, to: CGFloat(max(min(progress, 1.0),0)))
                .stroke(style: StrokeStyle(lineWidth: (progress==0) ? 0.0 : 10.0,lineCap: .round, lineJoin: .round))
                .animation(.linear(duration: 0.2), value: progress)
                .foregroundColor(Color.white.opacity(0.6))
                .rotationEffect(Angle(degrees: 270.0))
                
        }
        .frame(width: 50, height: 50)
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView(progress: 0.5, color: Color.red, opacity: 0.5)
    }
}
