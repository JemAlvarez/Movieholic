//

import Foundation

struct MovieModel {
    let adult: Bool
    let backdropURL: String
    let budget: Int
    let genres: [MovieDetailModel.Genre]
    let homepage: String?
    let imdbID: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let posterURL: String
    let productionCompanies: [ProductionCompany]
    let releaseDate: Date?
    let revenue: Int
    let runtime: Int?
    let tagline: String?
    let title: String
    let voteAverage: Double
    let cast: [Cast]
    let recommendations: [Recommendation]
    let trailerURL: String?
    
    struct Recommendation: Codable {
        let posterUrl: String
        let releaseDate: Date?
        let id: Int
        let title: String
        let backdropUrl: String
        let voteAverage: Double
    }
    
    struct ProductionCompany: Codable {
        let name: String
        let id: Int
        let logoUrl: String
    }
    
    struct Cast: Codable {
        let id: Int
        let name: String
        let profileUrl: String
        let character: String
    }
}

struct MovieDetailModel: Codable {
    let adult: Bool
    let backdrop_path: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let imdb_id: String?
    let original_language: String
    let original_title: String
    let overview: String?
    let poster_path: String?
    let production_companies: [ProductionCompany]
    let release_date: String
    let revenue: Int
    let runtime: Int?
    let tagline: String?
    let title: String
    let vote_average: Double
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
    struct ProductionCompany: Codable {
        let name: String
        let id: Int
        let logo_path: String?
    }
}

struct MovieCreditsModel: Codable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Codable {
        let id: Int
        let name: String
        let profile_path: String?
        let character: String
    }
}

struct MovieRecommendationsModel: Codable {
    let results: [Recommendation]
    
    struct Recommendation: Codable {
        let poster_path: String?
        let release_date: String
        let id: Int
        let title: String
        let backdrop_path: String?
        let vote_average: Double
    }
}

struct MovieVideoModel: Codable {
    let results: [Result]
    
    struct Result: Codable {
        let name: String
        let key: String
        let site: String
        let type: String
    }
}
