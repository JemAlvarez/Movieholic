//

import SwiftUI

struct FeaturedView: View {
    @StateObject var vm = FeaturedViewModel()
    
    var body: some View {
        VStack {
            if vm.featuredData != nil {
                ForEach(vm.featuredData!.results.indices) { i in
                    if let item = vm.featuredData!.results[i] {
                        if item.movieTitle != nil {
                            Text(item.movieTitle!)
                        } else if (item.tvName != nil) {
                            Text(item.tvName!)
                        }
                    }
                }
            }
        }
        .task {
            vm.request(for: .movie, in: .popular) { fetchedData in
                vm.featuredData = fetchedData
            }
        }
    }
}

struct FeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedView()
    }
}
