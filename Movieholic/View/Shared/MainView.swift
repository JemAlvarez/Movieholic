//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    
    var body: some View {
        ZStack {
            VStack {
                // different views
                switch sidebarViewModel.selectedView {
                case 1:
                    MediaView(viewTitle: "Movies", viewType: .movie)
                case 2:
                    MediaView(viewTitle: "TV Shows", viewType: .tv)
                case 3:
                    MediaView(viewTitle: "People", viewType: .people)
                default:
                    FeaturedView()
                }
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
