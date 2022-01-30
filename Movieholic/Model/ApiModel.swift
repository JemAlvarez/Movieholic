//

import Foundation

class APIModel {
    static let shared = APIModel()
    
    private let baseUrl = "https://api.themoviedb.org/3"
    private let imageBaseUrl = "https://image.tmdb.org/t/p"
    private let posterWidth = "/original"
    private let backdropWidth = "/original"
    
    // private function to request from any url and return any data, basic request function
    private func request(requestType: RequestType, requestUrl: String, params: [(key: String, value: String)]? = nil) async -> Data? {
        
        // default url string with the base url + the type of request + the api key
        var urlString = "\(baseUrl)\(requestType.rawValue)\(requestUrl)?api_key=\(APIKey.apiKey)"
        
        // add any params to the url string
        if let queryParams = params {
            for param in queryParams {
                urlString += "&\(param.key)=\(param.value)"
            }
        }
        
        // make url from url string
        guard let url = URL(string: urlString) else { return nil }
        
        // try to get data from url
        do {
            // data has Data and URLResponse
            let data = try await URLSession.shared.data(from: url)
            
            // return Data from data
            return data.0
        } catch {
            // print error if any and return nil in function
            print(error.localizedDescription)
            return nil
        }
    }
    
    // private request genres from id
    
    // get featured movies and tv
    func fetchFeatured(for requestType: RequestType, in requestCategory: RequestCategory) async -> FeaturedModel? {
        // date formatter to get date from string
        
        // try
        do {
            // await private request for the type and category and retunr nil if not possible
            guard let featuredData = await self.request(requestType: requestType, requestUrl: requestCategory.rawValue) else { return nil }
            
            // variable to store cleaned up featured model
            var featuredModel: FeaturedModel? = nil
            
            // if movie decode movie data model, else decode tv data model
            if requestType == .movie {
                let decodedFeaturedData = try JSONDecoder().decode(FeaturedMoviesDataModel.self, from: featuredData)
                
                
                // for each genre id request genre string
                // make string array with genres
                
                // generate featured model from decoded json data
                featuredModel = FeaturedModel(
                    id: decodedFeaturedData.id,
                    posterUrl: decodedFeaturedData.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(decodedFeaturedData.poster_path!)",
                    backdropUrl: decodedFeaturedData.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(decodedFeaturedData.backdrop_path!)",
                    releaseDate: Date(),
                    firstAirDate: nil,
                    tvName: nil,
                    movieTitle: <#T##String?#>,
                    overview: <#T##String#>,
                    genres: <#T##[String]#>,
                    voteAverage: <#T##Double#>)
            } else if requestType == .tv {
                let decodedFeaturedData = try JSONDecoder().decode(FeaturedTVDataModel.self, from: featuredData)
                
                
                // for each genre id request genre string
                // make string array with genres
                
                // generate featured model from decoded json data
                featuredModel = FeaturedModel(
                    id: decodedFeaturedData.id,
                    posterUrl: decodedFeaturedData.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(decodedFeaturedData.poster_path!)",
                    backdropUrl: decodedFeaturedData.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(decodedFeaturedData.backdrop_path!)",
                    releaseDate: nil,
                    firstAirDate: Date(),
                    tvName: <#T##String?#>,
                    movieTitle: nil,
                    overview: <#T##String#>,
                    genres: <#T##[String]#>,
                    voteAverage: <#T##Double#>)
            }
        } catch {
            // print error and return nil
            print(error.localizedDescription)
            return nil
        }
    }
}

extension APIModel {
    // types of request for api url requests (movie, tv, person)
    enum RequestType: String {
        case movie = "/movie"
        case tv = "/tv"
        case people = "/person"
    }
    
    // category of requests (popular, top rated, upcoming)
    enum RequestCategory: String {
        case popular = "/popular"
    }
}
