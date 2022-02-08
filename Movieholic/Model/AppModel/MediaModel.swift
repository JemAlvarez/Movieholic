//

import Foundation

// featured (popular, now playing, top rated, upcoming) movies
// featured (popular, on air, airing today, top rated) tv

struct MediaModel: Identifiable {
    let id: Int
    
    let posterUrl: String? // tv/movie
    let backdropUrl: String? // tv/movie
    let peopleProfileURL: String? // people
    
    let releaseDate: Date? // movie
    let firstAirDate: Date? // tv show
    
    let tvName: String? // tv show
    let movieTitle: String? // movie
    let peopleName: String? // people
    
    let overview: String?
    let genres: [String]?
    let voteAverage: Double?
}

struct MediaModelBase {
    let page: Int
    let results: [MediaModel]
    let totalPages: Int
}
