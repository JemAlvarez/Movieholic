//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    
    var body: some View {
        ZStack {
            // different views
            switch sidebarViewModel.selectedView {
            case 1:
                Text("Movies")
            case 2:
                Text("TV Shows")
            case 3:
                Text("People")
            default:
                FeaturedView()
            }
            
            // side bar view
            SidebarView()
            
            // search bar view
            SearchbarView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}