//

import SwiftUI

class FeaturedViewModel: ObservableObject {
    // storing data
    @Published var popular: MediaModelBase? = nil
    @Published var topRated: MediaModelBase? = nil
    @Published var nowPlayingMovies: MediaModelBase? = nil
    @Published var upcomingMovies: MediaModelBase? = nil
    @Published var onAirTVs: MediaModelBase? = nil
    @Published var airingTodayTVs: MediaModelBase? = nil
    
    // segmented pickers
    @Published var popularSelection = 0
    @Published var topRatedSelection = 0
    
    // request featured data
    @MainActor // run on main thread
    func request(for requestType: APIModel.RequestType, in requestCategory: APIModel.RequestCategory, params: [(key: String, value: String)]? = nil, callback: @escaping (MediaModelBase?) -> Void) {
        Task.init {
            let fetchedData = await APIModel.shared.fetchList(for: requestType, in: requestCategory, params: params)
            
            callback(fetchedData)
        }
    }
}

