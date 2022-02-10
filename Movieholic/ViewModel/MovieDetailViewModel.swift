//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movie: MovieModel? = nil
    
    @Published var showingPosterImage = false
    @Published var hoveringPoster = false
    
    @Published var temp = false
    
    @MainActor
    func fetch(for id: Int) async {
        let fetchedData = await APIModel.shared.fetchMovie(for: id)
        movie = fetchedData
    }
}
