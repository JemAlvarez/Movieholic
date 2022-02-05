import SwiftUI

//MARK: - View
extension View { // customize window
    func hostingWindowFinder() -> some View {
        self.overlay(
            HostingWindowFinder { window in
              if let window = window {
                  window.titlebarAppearsTransparent = true
                  window.titleVisibility = .hidden
              }
            }
        )
    }
}

extension View { // set window translucent background
    func windowBackground() -> some View {
        self.background(
            VisualEffect(material: .popover, blendingMode: .behindWindow)
                .ignoresSafeArea()
        )
    }
}

extension View { // change cursor
    func changeNSCursor(to cursor: NSCursor, for bool: Bool) {
         bool ? cursor.push() : NSCursor.pop()
    }
}

extension Date {
    // get string from date
    func getString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

extension String {
    // get date from string
    func getDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
}
