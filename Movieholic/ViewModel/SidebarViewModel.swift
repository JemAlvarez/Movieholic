//

import SwiftUI

class SidebarViewModel: ObservableObject {
    let sidebarButtons: [(name: String, icon: String)] = [("Featured", "house.fill"), ("Movies", "film.fill"), ("TV Shows", "tv.inset.filled"), ("People", "person.3.fill"), ("Collapse", "arrow.left.arrow.right")]
    
    @Published var sidebarExpanded = false
    @Published var selectedView = 0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("MainViewDidChange"), object: nil)
        }
    }
}
