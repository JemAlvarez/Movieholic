//

import SwiftUI

struct MoviesView: View {
    @StateObject var vm = MoviesViewModel()
    @State var columns = [GridItem()]
    @State var width: CGFloat = Sizes.minWidth
    
    var body: some View {
        getWindowSize()
        
        VStack {
            headerView()
            
            ScrollView {
                moviesGridView()
                
                Spacer()
                
                if vm.movies != nil {
                    PaginationView(currentPage: $vm.pageNum, totalPages: vm.movies!.totalPages)
                }
                
                FooterAttributionView()
            }
        }
        .padding(.leading, Sizes.sidebarShrunk)
        .padding(.top)
        .onChange(of: width) { newVal in
            withAnimation {
                switch width {
                case 0..<750:
                    columns = [GridItem()]
                case 750..<1000:
                    columns = [GridItem(), GridItem()]
                case 1000..<1300:
                    columns = [GridItem(), GridItem(), GridItem()]
                case 1300..<1800:
                    columns = [GridItem(), GridItem(), GridItem(), GridItem()]
                default:
                    columns = [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]
                }
            }
        }
        .onChange(of: vm.category) { newVal in
            vm.request(for: vm.category, params: [("page", "1")]) { data in
                vm.movies = data
            }
        }
        .task {
            vm.request(for: vm.category, params: [("page", "1")]) { data in
                vm.movies = data
            }
        }
    }
}

extension MoviesView {
    func headerView() -> some View {
        HStack {
            Text("Movies")
                .font(.largeTitle)
            
            Picker("", selection: $vm.category) {
                Text("Popular").tag(APIModel.RequestCategory.popular)
                Text("Top Rated").tag(APIModel.RequestCategory.topRated)
                Text("Now Playing").tag(APIModel.RequestCategory.nowPlayingMovies)
                Text("Upcoming").tag(APIModel.RequestCategory.upcomingMovies)
            }
            .pickerStyle(.segmented)
            .frame(width: 435)
            
            Spacer()
        }
        .padding(.leading)
    }
    
    func moviesGridView() -> some View {
        LazyVGrid(columns: columns, spacing: Sizes.cardSpacing) {
            if vm.movies != nil {
                ForEach(vm.movies!.results) { movie in
                    MoviesCardView(item: movie)
                }
            }
        }
        .padding(.top, 50)
        .padding(.horizontal, Sizes.leftPaddingSidebarShrunk)
        .frame(maxWidth: .infinity)
    }
    
    func getWindowSize() -> some View {
        GeometryReader { geo in
            Text("")
                .onChange(of: geo.size.width) { newValue in
                    width = newValue
                }
                .onAppear {
                    width = geo.size.width
                }
        }
        .frame(height: 0)
    }
}
