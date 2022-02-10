//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieModel? = nil
    @Published var windowSize: (width: CGFloat, height: CGFloat) = (.zero, .zero)
    
    @MainActor
    func fetch(for id: Int) async {
        let fetchedData = await APIModel.shared.fetchMovie(for: id)
        movie = fetchedData
    }
}
