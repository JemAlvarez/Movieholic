//

import SwiftUI

struct FeaturedView: View {
    @StateObject var vm = FeaturedViewModel()
    @StateObject var router = Router()
    
    var body: some View {
        Group {
            switch router.currentRoute {
            case .root:
                root()
            case .movie(let id):
                MovieDetailView(id: id)
            case .tv(let id):
                Text("TV \(id)")
            case .people(let id):
                Text("People \(id)")
            default:
                root()
            }
        }
        .transition(.move(edge: .leading))
        .environmentObject(router)
    }
}

extension FeaturedView {
    func root() -> some View {
        ScrollView {
            VStack (spacing: Sizes.cardSpacing) {
                // now playing
                if vm.nowPlayingMovies != nil {
                    CarouselView(items: vm.nowPlayingMovies!.results)
                } else {
                    CarouselView(items: [])
                }
                
                VStack {
                    // on air tvs
                    rowTitle(title: "TV Shows on the Air", data: vm.onAirTVs)
                    FeaturedRowView(data: vm.onAirTVs)
                }
                
                VStack {
                    // upcoming movies
                    rowTitle(title: "Upcoming Movies", data: vm.upcomingMovies)
                    FeaturedRowView(data: vm.upcomingMovies)
                }
                
                VStack {
                    // aring today tvs
                    rowTitle(title: "TV Shows Airing Today", data: vm.airingTodayTVs)
                    FeaturedRowView(data: vm.airingTodayTVs)
                }
                
                VStack {
                    // popular
                    rowTitleWithSelection(title: "Popular", selection: $vm.popularSelection, data: vm.popular)
                    FeaturedRowView(data: vm.popular)
                }
                
                VStack {
                    // top rated
                    rowTitleWithSelection(title: "Top Rated", selection: $vm.topRatedSelection, data: vm.topRated)
                    FeaturedRowView(data: vm.topRated)
                }
            }
            
            FooterAttributionView()
        }
        .ignoresSafeArea()
        .onChange(of: vm.popularSelection) { _ in // toggle between popular movies and tv shows
            vm.request(for: vm.popularSelection == 0 ? .movie : .tv, in: .popular) { fetchedData in
                vm.popular = fetchedData
            }
        }
        .onChange(of: vm.topRatedSelection) { _ in // toggle between top rated movies tv shows
            vm.request(for: vm.topRatedSelection == 0 ? .movie : .tv, in: .topRated) { fetchedData in
                vm.topRated = fetchedData
            }
        }
        .task {
            // popular movies
            vm.request(for: .movie, in: .popular) { fetchedData in
                vm.popular = fetchedData
            }
            
            // top rated movies
            vm.request(for: .movie, in: .topRated) { fetchedData in
                vm.topRated = fetchedData
            }
            
            // on air tvs
            vm.request(for: .tv, in: .onAirTVs) { fetchedData in
                vm.onAirTVs = fetchedData
            }
            
            // upcoming movies
            vm.request(for: .movie, in: .upcomingMovies) { fetchedData in
                vm.upcomingMovies = fetchedData
            }
            
            // airing today tvs
            vm.request(for: .tv, in: .airingTodayTVs) { fetchedData in
                vm.airingTodayTVs = fetchedData
            }
            
            // now playing
            vm.request(for: .movie, in: .nowPlayingMovies) { fetchedData in
                vm.nowPlayingMovies = fetchedData
            }
        }
    }
}

extension FeaturedView {
    func rowTitle(title: String, spacer: Bool = true, data: MediaModelBase?) -> some View {
        HStack {
            if data == nil { // if data hasnt loaded show progress view
                ProgressView()
                    .scaleEffect(0.5)
            }
            
            Text(title)
                .font(.headline)
            
            if spacer {
                Spacer()
            }
        }
        .padding(.leading, Sizes.leftPaddingSidebarShrunk)
    }
    
    func rowTitleWithSelection(title: String, selection: Binding<Int>, data: MediaModelBase?) -> some View {
        HStack {
            rowTitle(title: title, spacer: false, data: data)
            
            Picker("", selection: selection) {
                Text("Movies").tag(0)
                Text("TV Show").tag(1)
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            
            Spacer()
        }
    }
}
