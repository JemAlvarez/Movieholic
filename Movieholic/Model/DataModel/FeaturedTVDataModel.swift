//

import Foundation

struct FeaturedTVDataModel: Decodable { // tv JSON data model
    let poster_path: String?
    let overview: String
    let genre_ids: [Int]
    let id: Int
    let name: String
    let backdrop_path: String?
    let first_air_date: String
    let vote_average: Double
}
