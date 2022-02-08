//

import SwiftUI

class MediaViewModel: ObservableObject {
    var requestType: APIModel.RequestType? = nil
    @Published var items: MediaModelBase? = nil
    @Published var category: APIModel.RequestCategory = .popular {
        didSet {
            pageNum = 1
        }
    }
    @Published var pageNum = 1 {
        didSet {
            Task.init {
                await request(for: requestType ?? .movie, in: category, params: [("page", "\(pageNum)")]) { data in
                    self.items = data
                }
            }
        }
    }
    
    // request movies
    @MainActor // run on main thread
    func request(for requestType: APIModel.RequestType, in requestCategory: APIModel.RequestCategory, params: [(key: String, value: String)]? = nil, callback: @escaping (MediaModelBase?) -> Void) {
        Task.init {
            let fetchedData = await APIModel.shared.fetchList(for: requestType, in: requestCategory, params: params)
            
            callback(fetchedData)
        }
    }
}
 
