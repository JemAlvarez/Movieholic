//

import Foundation

struct MovieListDataModel: Decodable {
    let poster_path: String?
    let release_date: String
    let id: Int
    let title: String
    let vote_average: Double
}

struct MovieListDataModelBase: Decodable {
    let page: Int
    let results: [MovieListDataModel]
    let total_pages: Int
}
