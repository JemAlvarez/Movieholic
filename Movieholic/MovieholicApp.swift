//

import SwiftUI

@main
struct MovieholicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // resizable
                .frame(minWidth: 700, minHeight: 750)
                .windowBackground()
                .hostingWindowFinder()
        }
    }
}
