//

import Foundation

struct FeaturedMoviesDataModel: Decodable { // movie JSON data model
    let poster_path: String?
    let overview: String
    let genre_ids: [Int]
    let id: Int
    let title: String
    let backdrop_path: String?
    let release_date: String
    let vote_average: Double
}

struct FeaturedMoviesDataModelBase: Decodable { // base json
    let page: Int
    let results: [FeaturedMoviesDataModel]
}
