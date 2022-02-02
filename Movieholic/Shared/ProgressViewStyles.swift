//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor: Color
    var strokeWidth: Int
    var size: (width: CGFloat, height: CGFloat)
    
    var filledBackground = false
    var backgroundColor = Color.gray

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            if filledBackground {
                Circle()
                    .stroke(backgroundColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                    .background(Circle().fill(backgroundColor))
            } else {
                Circle()
                    .stroke(strokeColor.opacity(0.3), style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
            }
            
            Circle()
                .trim(from: 0, to: CGFloat(fractionCompleted))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size.width, height: size.height)
    }
}

