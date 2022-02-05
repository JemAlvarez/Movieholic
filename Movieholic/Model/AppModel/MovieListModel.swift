//

import Foundation

struct MovieListModel: Identifiable {
    let posterUrl: String?
    let releaseDate: Date?
    let id: Int
    let title: String
    let voteAverage: Double
}

struct MovieListModelBase {
    let page: Int
    let results: [MovieListModel]
    let totalPages: Int
}
