//

import SwiftUI

class Router: ObservableObject {
    @Published var routes: [Routes] = [.root] // list of routes
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(mainViewDidChangeSelector), name: NSNotification.Name("MainViewDidChange"), object: nil)
    }
    
    var currentRoute: Routes? { // current route to display
        routes.last
    }
    
    func push(_ route: Routes) {
        withAnimation {
            routes.append(route)
        }
    }
    
    @discardableResult
    func pop() -> Routes? {
        withAnimation {
            routes.popLast()
        }
    }
    
    @objc func mainViewDidChangeSelector() {
        withAnimation {
            routes = [.root]
        }
    }
}
