//

import Foundation

struct MovieDetailDataModel: Codable {
    let adult: Int
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
    let video: Bool
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

struct MovieCreditsDataModel: Codable {
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
        let backdrop_path: String
        let vote_average: Double
    }
}

struct MovieVideoModel: Codable {
    let name: String
    let key: String
    let site: String
}
