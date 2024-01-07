//
//  CircularProgressView.swift
//  GameClock
//
//  Created by Christian Rodriguez on 4/28/23.
//
import Foundation
import SwiftUI

struct RectangularProgressView: View {
    @Binding var progress: Float

    var body: some View {
        ZStack {
            // Gray circle
            Rectangle()
                .stroke(lineWidth: 8.0)
                .foregroundColor(.gray)
                .frame(width: .infinity, height: .infinity)

            Rectangle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0,
                    lineCap: .round, lineJoin: .round))
                .foregroundColor(ColorPalette.primaryForeground)
                // Ensures the animation starts from 12 o'clock
//                .rotationEffect(Angle(degrees: 270))
                .frame(width: .infinity, height: .infinity)
        }
        // The progress animation will animate over 1 second which
        // allows for a continuous smooth update of the ProgressView
        .animation(.linear(duration: 1.0), value: progress)
        
    }
}


//struct CircularProgressView_Previews: PreviewProvider {
//    @State var prog : Float = 1.5
//    static var previews: some View {
//        CircularProgressView(progress: $prog)
//    }
//}

