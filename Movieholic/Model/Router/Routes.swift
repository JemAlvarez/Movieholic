//

import Foundation

enum Routes: Equatable {
    case root
    case movie(id: Int)
    case tv(id: Int)
    case people(id: Int)
}
