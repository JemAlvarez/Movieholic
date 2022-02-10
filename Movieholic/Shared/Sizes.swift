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
    
    // padding for sidebar
    static let leftPaddingSidebarShrunk = Sizes.sidebarShrunk * 1.3
    static let leftPaddingSidebarExpanded = Sizes.sidebarExpanded * 1.3
    
    // min window sizes
    static let minWidth: CGFloat = 700
    static let minHeight: CGFloat = 750
    
    // backdrop image height
    static let backdropHeight: CGFloat = 700
    
    // spcaing for the cards vertically
    static let cardSpacing: CGFloat = 30
    
    // buttons sizes
    static let navButtonSize: CGFloat = 40
}
