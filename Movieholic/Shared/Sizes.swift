//

import SwiftUI

struct Sizes {
    // sidebar
    static let sidebarShrunk: CGFloat = 70
    static let sidebarExpanded: CGFloat = 200
    
    // fonts
    static let fontSizeNavButtons: Font = .title2
    static let fontSizeNavText: Font = .title3
    
    // searchbar
    static let searchbarWidth: CGFloat = 200
    
    // media card size
    static let mediaCardSize: (width: CGFloat, height: CGFloat) = (219, 330)
    
    // padding for sidebar shrunk
    static let leftPaddingSidebar = Sizes.sidebarShrunk * 1.3
}
