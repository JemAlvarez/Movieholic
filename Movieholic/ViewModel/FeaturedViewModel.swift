//

import SwiftUI

class FeaturedViewModel: ObservableObject {
    // storing data
    @Published var popular: FeaturedModelBase? = nil
    @Published var topRated: FeaturedModelBase? = nil
    @Published var nowPlayingMovies: FeaturedModelBase? = nil
    @Published var upcomingMovies: FeaturedModelBase? = nil
    @Published var onAirTVs: FeaturedModelBase? = nil
    @Published var airingTodayTVs: FeaturedModelBase? = nil
    
    // segmented pickers
    @Published var popularSelection = 0
    @Published var topRatedSelection = 0
    
    // request featured data
    @MainActor // run on main thread
    func request(for requestType: APIModel.RequestType, in requestCategory: APIModel.RequestCategory, callback: @escaping (FeaturedModelBase?) -> Void) {
        Task.init {
            let fetchedData = await APIModel.shared.fetchFeatured(for: requestType, in: requestCategory)
            
            callback(fetchedData)
        }
    }
}

