//

import SwiftUI

class SearchbarViewModel: ObservableObject {
    @Published var showingBar = false
    @Published var isHoveringToggleButton = false
    @Published var isHoveringClearButton = false
    @Published var searchQuery = ""
    @Published var searchbarWidth: CGFloat = 0
}
