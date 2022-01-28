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
