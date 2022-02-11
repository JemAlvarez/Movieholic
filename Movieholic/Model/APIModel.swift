//

import Foundation

//MARK: - request functions and variables
class APIModel {
    static let shared = APIModel()
    
    private let baseUrl = "https://api.themoviedb.org/3"
    private let imageBaseUrl = "https://image.tmdb.org/t/p"
    private let posterWidth = "/original"
    private let backdropWidth = "/original"
    private let profileWidth = "/original"
    private let logoWidth = "/original"
    private let youtubeBaseUrl = "https://youtube.com/watch?v="
    private let imdbBaseUrl = "https://www.imdb.com/title/"
    private let tmdbDateFormat = "yy-MM-dd"
}

//MARK: - requests

// get lists movies and tv and people
extension APIModel {
    func fetchList(for requestType: RequestType, in requestCategory: RequestCategory, params: [(key: String, value: String)]? = nil) async -> MediaModelBase? {
        // initial base model & page number
        var featuredModelBase: MediaModelBase? = nil
        var pageNum = 1
        
        // initial array of featured model
        var featuredModelArray: [MediaModel] = []
        
        // total pages
        var totalPages = 0
        
        // try
        do {
            // await private request for the type and category and retunr nil if not possible
            guard let featuredData = await self.request(requestType: requestType, requestUrl: requestCategory.rawValue, params: params) else { return nil }
            
            // if movie decode movie data model, else decode tv data model
            if requestType == .movie {
                // json decoded data
                let decodedFeaturedData = try JSONDecoder().decode(MoviesListDataModelBase.self, from: featuredData)
                
                // set total pages
                totalPages = decodedFeaturedData.total_pages
                
                // loop through all decoded models
                for dataModel in decodedFeaturedData.results {
                    // get the genres strings
                    let genres = getGenres(for: dataModel.genre_ids)
                    
                    // generate featured model from decoded json data
                    let featuredModel = MediaModel(
                        id: dataModel.id,
                        posterUrl: dataModel.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(dataModel.poster_path!)",
                        backdropUrl: dataModel.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(dataModel.backdrop_path!)",
                        peopleProfileURL: nil,
                        releaseDate: dataModel.release_date.getDate(format: tmdbDateFormat),
                        firstAirDate: nil,
                        tvName: nil,
                        movieTitle: dataModel.title,
                        peopleName: nil,
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
                let decodedFeaturedData = try JSONDecoder().decode(TVListDataModelBase.self, from: featuredData)
                
                // set total pages
                totalPages = decodedFeaturedData.total_pages
                
                // loop through all decoded models
                for dataModel in decodedFeaturedData.results {
                    // get the genres strings
                    let genres = getGenres(for: dataModel.genre_ids)
                    
                    // generate featured model from decoded json data
                    let featuredModel = MediaModel(
                        id: dataModel.id,
                        posterUrl: dataModel.poster_path == nil ? nil : "\(imageBaseUrl)\(posterWidth)\(dataModel.poster_path!)",
                        backdropUrl: dataModel.backdrop_path == nil ? nil : "\(imageBaseUrl)\(backdropWidth)\(dataModel.backdrop_path!)",
                        peopleProfileURL: nil,
                        releaseDate: nil,
                        firstAirDate: dataModel.first_air_date.getDate(format: tmdbDateFormat),
                        tvName: dataModel.name,
                        movieTitle: nil,
                        peopleName: nil,
                        overview: dataModel.overview,
                        genres: genres,
                        voteAverage: dataModel.vote_average)
                    
                    // data created model to array of models
                    featuredModelArray.append(featuredModel)
                    
                    // set the page num to use in base model returned
                    pageNum = decodedFeaturedData.page
                }
            } else if requestType == .people {
                // json decoded data
                let decodedFeaturedData = try JSONDecoder().decode(PeopleListDataModelBase.self, from: featuredData)
                
                // set total pages
                totalPages = decodedFeaturedData.total_pages
                
                // loop through all decoded models
                for dataModel in decodedFeaturedData.results {
                    // generate featured model from decoded json data
                    let featuredModel = MediaModel(
                        id: dataModel.id,
                        posterUrl: nil,
                        backdropUrl: nil,
                        peopleProfileURL: dataModel.profile_path == nil ? nil : "\(imageBaseUrl)\(profileWidth)\(dataModel.profile_path!)",
                        releaseDate: nil,
                        firstAirDate: nil,
                        tvName: nil,
                        movieTitle: nil,
                        peopleName: dataModel.name,
                        overview: nil,
                        genres: nil,
                        voteAverage: nil)
                    
                    // data created model to array of models
                    featuredModelArray.append(featuredModel)
                    
                    // set the page num to use in base model returned
                    pageNum = decodedFeaturedData.page
                }
            }
            
            // make the base model to return
            featuredModelBase = MediaModelBase(page: pageNum, results: featuredModelArray, totalPages: totalPages)
            
            return featuredModelBase
        } catch {
            // print error and return nil
            print(error.localizedDescription)
            print(error)
            return nil
        }
    }
}

// fetch detailed
extension APIModel {
    func fetchMovie(for id: Int) async -> MovieModel? {
        // movie/id - details
        guard let movieDetailData = await self.request(requestType: .movie, requestUrl: "/\(id)", params: nil) else {return nil}
        
        // movie/id/credits - movie cast
        guard let movieCreditsData = await self.request(requestType: .movie, requestUrl: "/\(id)/credits", params: nil) else {return nil}
        
        //  movie/id/recommendations
        guard let movieRecommendationsData = await self.request(requestType: .movie, requestUrl: "/\(id)/recommendations", params: nil) else {return nil}
        
        //  movie/id/videos
        guard let movieVideosData = await self.request(requestType: .movie, requestUrl: "/\(id)/videos", params: nil) else {return nil}
        
        do {
            // json decoded movie details
            let decodedMovieDetails = try JSONDecoder().decode(MovieDetailModel.self, from: movieDetailData)
            
            // json decoded movie credits
            let decodedMovieCredits = try JSONDecoder().decode(MovieCreditsModel.self, from: movieCreditsData)
            
            // json decoded movie recommendations
            let decodedMovieRecommendations = try JSONDecoder().decode(MovieRecommendationsModel.self, from: movieRecommendationsData)
            
            // json decoded movie videos
            let decodedMovieVideos = try JSONDecoder().decode(MovieVideoModel.self, from: movieVideosData)
            
            // movie trailer
            var movieTrailer: String? = nil
            // movie companies
            var movieCompanies: [MovieModel.ProductionCompany] = []
            // movie cast
            var movieCast: [MovieModel.Cast] = []
            // movie recommendations
            var movieRecommendations: [MovieModel.Recommendation] = []
            
            // get movie companies
            for company in decodedMovieDetails.production_companies {
                let newCompany = MovieModel.ProductionCompany(
                    name: company.name,
                    id: company.id,
                    logoUrl: company.logo_path != nil ? "\(imageBaseUrl)\(logoWidth)\(company.logo_path!)" : ""
                )
                
                movieCompanies.append(newCompany)
            }
            
            // get movie cast
            for cast in decodedMovieCredits.cast {
                let newCastMemeber = MovieModel.Cast(
                    id: cast.id,
                    name: cast.name,
                    profileUrl: cast.profile_path != nil ? "\(imageBaseUrl)\(profileWidth)\(cast.profile_path!)" : "",
                    character: cast.character)
                
                movieCast.append(newCastMemeber)
            }
            
            // get movie recommendations
            for recommendation in decodedMovieRecommendations.results {
                let newRecommendation = MovieModel.Recommendation(
                    posterUrl: recommendation.poster_path != nil ? "\(imageBaseUrl)\(profileWidth)\(recommendation.poster_path!)" : "",
                    releaseDate: recommendation.release_date.getDate(format: tmdbDateFormat),
                    id: recommendation.id,
                    title: recommendation.title,
                    backdropUrl: recommendation.backdrop_path != nil ? "\(imageBaseUrl)\(profileWidth)\(recommendation.backdrop_path!)" : "",
                    voteAverage: recommendation.vote_average
                )
                
                movieRecommendations.append(newRecommendation)
            }
            
            // get movie trailer
            // if movie has vide
            // for each video fetched and decoded
            for video in decodedMovieVideos.results {
                // if the video source is youtube and type is trailer
                if video.site.lowercased() == "youtube" && video.type.lowercased() == "trailer" {
                    // send that video url to the model
                    movieTrailer = "\(youtubeBaseUrl)\(video.key)"
                    break
                }
            }
            
//            print(decodedMovieDetails.budget)
            
            // return model suitable for app
            return MovieModel(
                adult: decodedMovieDetails.adult,
                backdropURL: decodedMovieDetails.backdrop_path == nil ? "" : "\(imageBaseUrl)\(backdropWidth)\(decodedMovieDetails.backdrop_path!)",
                budget: decodedMovieDetails.budget,
                genres: decodedMovieDetails.genres,
                homepage: decodedMovieDetails.homepage,
                imdbID: decodedMovieDetails.imdb_id == nil ? "" : "\(imdbBaseUrl)\(decodedMovieDetails.imdb_id!)",
                originalLanguage: decodedMovieDetails.original_language,
                originalTitle: decodedMovieDetails.original_title,
                overview: decodedMovieDetails.overview,
                posterURL: decodedMovieDetails.poster_path == nil ? "" :
                    "\(imageBaseUrl)\(posterWidth)\(decodedMovieDetails.poster_path!)",
                productionCompanies: movieCompanies,
                releaseDate: decodedMovieDetails.release_date.getDate(format: tmdbDateFormat),
                revenue: decodedMovieDetails.revenue,
                runtime: decodedMovieDetails.runtime,
                tagline: decodedMovieDetails.tagline,
                title: decodedMovieDetails.title,
                voteAverage: decodedMovieDetails.vote_average,
                cast: movieCast,
                recommendations: movieRecommendations,
                trailerURL: movieTrailer
            )
        } catch {
            print(error.localizedDescription)
            print(error)
            return nil
        }
    }
}

//MARK: - base request
extension APIModel {
    // private function to request from any url and return any data, basic request function
    private func request(requestType: RequestType, requestUrl: String, params: [(key: String, value: String)]? = nil) async -> Data? {
        
        // default url string with the base url + the type of request + the api key
        var urlString = "\(baseUrl)\(requestType.rawValue)\(requestUrl)?api_key=\(APIKey.apiKey)&region=US"
        
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
            print(error)
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
        case topRated = "/top_rated"
        case nowPlayingMovies = "/now_playing"
        case upcomingMovies = "/upcoming"
        case onAirTVs = "/on_the_air"
        case airingTodayTVs = "/airing_today"
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
