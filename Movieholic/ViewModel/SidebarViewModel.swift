//

import SwiftUI

class SidebarViewModel: ObservableObject {
    let sidebarButtons: [(name: String, icon: String)] = [("Featured", "house.fill"), ("Movies", "film.fill"), ("TV Shows", "tv.inset.filled"), ("People", "person.3.fill")]
    
    @Published var hovering = false
    @Published var selectedView = 0
}
