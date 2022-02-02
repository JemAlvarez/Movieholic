//

import SwiftUI

@main
struct MovieholicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // resizable
                .frame(minWidth: 550, minHeight: 300)
                .windowBackground()
                .hostingWindowFinder()
        }
    }
}
