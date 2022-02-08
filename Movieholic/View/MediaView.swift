//

import SwiftUI

struct MediaView: View {
    let viewTitle: String
    let viewType: APIModel.RequestType
    
    @StateObject var router = Router()
    
    @StateObject var vm = MediaViewModel()
    @State var columns = [GridItem()]
    @State var width: CGFloat = Sizes.minWidth
    
    var body: some View {
        getWindowSize() // get window size with geometry reader to dynamically change the columns
        
        Group {
            switch router.currentRoute {
            case .root:
                root() // main view for this navigation
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
        .transition(.move(edge: .leading)) // appear as the default navigation transition
        .environmentObject(router) // pass the router to child views
    }
}

extension MediaView {
    func root() -> some View {
        VStack {
            headerView()
            
            ScrollView {
                mediaGridView()
                
                Spacer()
                
                if vm.items != nil {
                    PaginationView(currentPage: $vm.pageNum, totalPages: vm.items!.totalPages)
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
            vm.request(for: viewType, in: vm.category, params: [("page", "1")]) { data in
                vm.items = data
            }
        }
        .task {
            vm.request(for: viewType, in: vm.category, params: [("page", "1")]) { data in
                vm.items = data
            }
        }
        .onAppear {
            vm.requestType = viewType
        }
    }
}

extension MediaView {
    func headerView() -> some View {
        HStack {
            Text(viewTitle)
                .font(.largeTitle)
            
            if viewType != .people { // show no picker for poeple
                Picker("", selection: $vm.category) {
                    Text("Popular").tag(APIModel.RequestCategory.popular)
                    Text("Top Rated").tag(APIModel.RequestCategory.topRated)
                    
                    if viewType == .movie {
                        Text("Now Playing").tag(APIModel.RequestCategory.nowPlayingMovies)
                        Text("Upcoming").tag(APIModel.RequestCategory.upcomingMovies)
                    } else if viewType == .tv {
                        Text("On the Air").tag(APIModel.RequestCategory.onAirTVs)
                        Text("Airing Today").tag(APIModel.RequestCategory.airingTodayTVs)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 435)
            }
            
            Spacer()
        }
        .padding(.leading)
    }
    
    func mediaGridView() -> some View {
        LazyVGrid(columns: columns, spacing: Sizes.cardSpacing) {
            if vm.items != nil {
                ForEach(vm.items!.results) { item in
                    MediaCardView(item: item)
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
