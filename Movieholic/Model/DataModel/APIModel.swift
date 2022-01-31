//

import Foundation

//MARK: - request functions and variables
class APIModel {
    static let shared = APIModel()
    
    private let baseUrl = "https://api.themoviedb.org/3"
    private let imageBaseUrl = "https://image.tmdb.org/t/p"
    private let posterWidth = "/original"
    private let backdropWidth = "/original"
    
    // get featured movies and tv
    func fetchFeatured(for requestType: RequestType, in requestCategory: RequestCategory) async -> FeaturedModelBase? {
        // initial base model & page number
        var featuredModelBase: FeaturedModelBase? = nil
        var pageNum = 1
        
        // initial array of featured model
        var featuredModelArray: [FeaturedModel] = []
        
        // date formatter to get date from string
        let dateFormatter = DateFormatter()
        // set formatter date format from json data
        dateFormatter.dateFormat = "yy-MM-dd"
        
        // try
        do {
            // await private request for the type and category and retunr nil if not possible
            guard let featuredData = await self.request(requestType: requestType, requestUrl: requestCategory.rawValue) else { return nil }
            
            // if movie decode movie data model, else decode tv data model
            if requestType == .movie {
                // json decoded data
                let decodedFeaturedData = try JSONDecoder().decode(FeaturedMoviesDataModelBase.self, from: featuredData)
                
                // loop through all decoded models
                for dataModel in decodedFeaturedData.results {
                    // get the genres strings
                    let genres = getGenres(for: dataModel.genre_ids)
                    
                    // generate featured model from decoded json data
                    let featuredModel = FeaturedModel(
                        id: dataModel.id,
                        posterUrl: dataModel.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(dataModel.poster_path!)",
                        backdropUrl: dataModel.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(dataModel.backdrop_path!)",
                        releaseDate: dateFormatter.date(from: dataModel.release_date),
                        firstAirDate: nil,
                        tvName: nil,
                        movieTitle: dataModel.title,
                        overview: dataModel.overview,
                        genres: genres,
                        voteAverage: dataModel.vote_average)
                    
                    // data created model to array of models
                    featuredModelArray.append(featuredModel)
                    
                    // set the page num to use in base model returned
                    pageNum = decodedFeaturedData.page
                }
            } else if requestType == .tv {
                // json decoded data
                let decodedFeaturedData = try JSONDecoder().decode(FeaturedTVDataModelBase.self, from: featuredData)
                
                // loop through all decoded models
                for dataModel in decodedFeaturedData.results {
                    // get the genres strings
                    let genres = getGenres(for: dataModel.genre_ids)
                    
                    // generate featured model from decoded json data
                    let featuredModel = FeaturedModel(
                        id: dataModel.id,
                        posterUrl: dataModel.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(dataModel.poster_path!)",
                        backdropUrl: dataModel.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(dataModel.backdrop_path!)",
                        releaseDate: nil,
                        firstAirDate: dateFormatter.date(from: dataModel.first_air_date),
                        tvName: dataModel.name,
                        movieTitle: nil,
                        overview: dataModel.overview,
                        genres: genres,
                        voteAverage: dataModel.vote_average)
                    
                    // data created model to array of models
                    featuredModelArray.append(featuredModel)
                    
                    // set the page num to use in base model returned
                    pageNum = decodedFeaturedData.page
                }
            }
            
            // make the base model to return
            featuredModelBase = FeaturedModelBase(page: pageNum, results: featuredModelArray)
            
            return featuredModelBase
        } catch {
            // print error and return nil
            print(error.localizedDescription)
            return nil
        }
    }
}

//MARK: - base request
extension APIModel {
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
}

//MARK: - request types and categories for url building
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

//MARK: - genres
extension APIModel {
    // genres ids
    static let genreIds: [(id: Int, name: String)] = [
        (12, "Adventure"),
        (14, "Fantasy"),
        (16, "Animation"),
        (18, "Drama"),
        (27, "Horror"),
        (28, "Action"),
        (35, "Comedy"),
        (36, "History"),
        (37, "Western"),
        (53, "Thriller"),
        (80, "Crime"),
        (99, "Documentary"),
        (878, "Science Fiction"),
        (9648, "Mystery"),
        (10402, "Music"),
        (10749, "Romance"),
        (10751, "Family"),
        (10752, "War"),
        (10759, "Action & Adventure"),
        (10762, "Kids"),
        (10763, "News"),
        (10764, "Reality"),
        (10765, "Sci-Fi & Fantasy"),
        (10766, "Soap"),
        (10767, "Talk"),
        (10768, "War & Politics"),
        (10770, "TV Movie"),
    ]
    
    // get array of genre strings
    private func getGenres(for ids: [Int]) -> [String] {
        // make string array with genres
        var genres: [String] = []
        
        // for each genre id request genre string
        for genre in APIModel.genreIds { // for each possible genre category
            if ids.contains(genre.id) { // if the decoded json data genres contains the current genre
                genres.append(genre.name) // add that genre name to the genres array of string
            }
        }
        
        return genres
    }
}
