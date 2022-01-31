//

import SwiftUI

class FeaturedViewModel: ObservableObject {
    @Published var featuredData: FeaturedModelBase? = nil
    
    // request featured data
    @MainActor // run on main thread
    func request(for requestType: APIModel.RequestType, in requestCategory: APIModel.RequestCategory, callback: @escaping (FeaturedModelBase?) -> Void) {
        Task.init {
            let fetchedData = await APIModel.shared.fetchFeatured(for: requestType, in: requestCategory)
            
            callback(fetchedData)
        }
    }
}
