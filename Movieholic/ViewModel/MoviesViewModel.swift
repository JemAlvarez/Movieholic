//

import SwiftUI

class MoviesViewModel: ObservableObject {
    @Published var movies: MovieListModelBase? = nil
    @Published var category: APIModel.RequestCategory = .popular
    @Published var pageNum = 1 {
        didSet {
            Task.init {
                await request(for: category, params: [("page", "\(pageNum)")]) { data in
                    self.movies = data
                }
            }
        }
    }
    
    // request movies
    @MainActor // run on main thread
    func request(for requestCategory: APIModel.RequestCategory, params: [(key: String, value: String)]? = nil, callback: @escaping (MovieListModelBase?) -> Void) {
        Task.init {
            let fetchedData = await APIModel.shared.fetchMovies(for: requestCategory, params: params)
            
            callback(fetchedData)
        }
    }
}
 
