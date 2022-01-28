//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    
    var body: some View {
        ZStack {
            switch sidebarViewModel.selectedView {
            case 1:
                Text("Movies")
            case 2:
                Text("TV Shows")
            case 3:
                Text("People")
            default:
                Text("Featured")
            }
            
            // side bar view
            SidebarView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
