//

import SwiftUI

struct RoutingView<V: View>: View {
    @EnvironmentObject var router: Router
    
    let root: V
    
    var body: some View {
        Group {
            switch router.currentRoute {
            case .root:
                root // main view for this navigation
            case .movie(let id):
                MovieDetailView(id: id)
            case .tv(let id):
                Text("TV \(id)")
            case .people(let id):
                Text("People \(id)")
            default:
                root
            }
        }
        .transition(.move(edge: .leading)) // appear as the default navigation transition
        .environmentObject(router) // pass the router to child views
    }
}
