//

import SwiftUI

struct ContentView: View {
    @StateObject var sidebarViewModel = SidebarViewModel()
    
    var body: some View {
        MainView()
            .environmentObject(sidebarViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
