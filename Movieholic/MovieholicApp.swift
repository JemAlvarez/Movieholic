//

import SwiftUI

@main
struct MovieholicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // resizable
                .frame(minWidth: Sizes.minWidth, minHeight: Sizes.minHeight)
                .windowBackground()
                .hostingWindowFinder()
        }
    }
}
