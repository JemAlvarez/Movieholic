//

import SwiftUI
import AppKit

struct RoundedCornerRectangleShape: Shape {
    var radius: CGFloat = 0.2
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // offset for lines before the corner, for the curve
        let offset = rect.maxY * radius
        
        // move to bottom right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // add line to top right plus the offset on y
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + offset))
        // add curve to top right minus the offset on x
        path.addQuadCurve(to: CGPoint(x: rect.maxX - offset, y: rect.minY), control: CGPoint(x: rect.maxX, y: rect.minY))
        // add line to top left
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        // add line to bottom left minus offset on y
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - offset))
        // add curve to bottom left plus offset on x
        path.addQuadCurve(to: CGPoint(x: rect.minX + offset, y: rect.maxY), control: CGPoint(x: rect.minX, y: rect.maxY))
        // add line to bottom right
        path.closeSubpath()
        
        return path
    }
}
