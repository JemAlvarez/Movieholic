//

import Foundation

// featured (popular, now playing, top rated, upcoming) movies
// featured (popular, on air, airing today, top rated) movies

struct FeaturedModel {
    let id: Int
    
    let posterUrl: String?
    let backdropUrl: String?
    
    let releaseDate: Date? // movie
    let firstAirDate: Date? // tv show
    
    let tvName: String? // tv show
    let movieTitle: String? // movie
    
    let overview: String
    let genres: [String]
    let voteAverage: Double
}

struct FeaturedModelBase {
    let page: Int
    let results: [FeaturedModel]
}
