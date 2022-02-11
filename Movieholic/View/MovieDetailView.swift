// backdrop image not staying at backdropheight

import SwiftUI

struct MovieDetailView: View {
    @Namespace var animation
    @EnvironmentObject var router: Router
    @State var id: Int
    
    @StateObject var vm = MovieDetailViewModel()
    
    var body: some View {
        VStack {
            root()
            
            if vm.movie != nil {
                ForEach(vm.movie!.recommendations, id: \.self.id) { recom in
                    Button(action: {
                        router.push(.movie(id: recom.id))
                    }) {
                        Text(recom.title)
                    }
                }
            }
        }
    }
}

//MARK: - big components
extension MovieDetailView {
    // root
    func root() -> some View {
        ZStack {
            if vm.movie != nil {
                content()
                    .overlay(bigPosterBackground())
                
                if vm.showingPosterImage {
                    posterImage(small: false)
                }
            } else {
                ProgressView()
            }
        }
        .foregroundColor(.primary)
        .ignoresSafeArea()
        .onRouteChange(currentRoute: router.currentRoute) { newId in
            withAnimation {
                id = newId
                vm.movie = nil
            }
        }
        .onChange(of: id) { newValue in
            Task.init {
                await vm.fetch(for: id)
            }
        }
        .task {
            await vm.fetch(for: id)
        }
    }
    
    // whole content
    func content() -> some View {
        ScrollView {
            VStack {
                heroSection()
                
                VStack {
                    horizontalScrollInfo()
                }
                .padding(.leading, Sizes.sidebarShrunk)
                .padding()
            }
        }
    }
    
    // hero section
    func heroSection() -> some View {
        ZStack(alignment: .top) {
            backdropImg()
            
            backButton()
            
            heroInfo()
        }
        .frame(height: Sizes.backdropHeight)
        .ignoresSafeArea()
    }
}

//MARK: - hero section
extension MovieDetailView {
    
    // small poster
    func posterImage(small: Bool = true) -> some View {
        VStack {
            AsyncImage(url: URL(string: vm.movie!.posterURL)) { img in
                Button(action: {
                    if small {
                        withAnimation(.spring()) {
                            vm.showingPosterImage = true
                        }
                    }
                }) {
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            small ?
                            ZStack {
                                VisualEffect(material: .popover, blendingMode: .withinWindow)
                                
                                Image(systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
                                    .font(.largeTitle)
                            }
                                .opacity(vm.hoveringPoster ? 1 : 0)
                            : nil
                        )
                        .cornerRadius(5)
                        .onHover { hovering in
                            if small {
                                changeNSCursor(to: .pointingHand, for: hovering)
                                
                                withAnimation {
                                    vm.hoveringPoster = hovering
                                }
                            }
                        }
                }
                .buttonStyle(.borderless)
            } placeholder: {
                Image(systemName: "photo")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.secondary.opacity(0.7))
                    .font(.largeTitle)
                    .cornerRadius(10)
            }
        }
        .matchedGeometryEffect(id: "posterImage", in: animation)
        .frame(width: small ? Sizes.mediaCardSize.width : Sizes.mediaCardSize.width * 2.5, height: small ? Sizes.mediaCardSize.height : Sizes.mediaCardSize.height * 2.5)
        .padding(.leading, small ? 0 : Sizes.sidebarShrunk)
    }
    
    // backdrop image
    func backdropImg() -> some View {
        GeometryReader{ geo in
            VStack {
                AsyncImage(url: URL(string: vm.movie!.backdropURL)) { img in
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: Sizes.backdropHeight)
                        .clipped()
                } placeholder: {
                    Rectangle().fill(.secondary)
                }
            }
            .frame(width: geo.size.width)
            .opacity(0.3)
        }
    }
    
    // navigation back button
    func backButton() -> some View {
        HStack {
            Button(action: {
                router.pop()
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: Sizes.navButtonSize, height: Sizes.navButtonSize)
            }
            .buttonStyle(.borderless)
            .background(VisualEffect(material: .popover, blendingMode: .withinWindow).clipShape(Circle()))
            
            Spacer()
        }
        .padding(.leading, Sizes.sidebarShrunk)
        .padding()
    }
    
    // movie info in hero section
    func heroInfo() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                posterImage()
                
                VStack(alignment: .leading, spacing: 20) {
                    // title and yaer
                    HStack {
                        Text(vm.movie!.title)
                            .fontWeight(.bold)
                        
                        Text("(\(vm.movie!.releaseDate?.getString(format: "yyyy") ?? "-"))")
                            .opacity(0.7)
                    }
                    .font(.largeTitle)
                    .lineLimit(1)
                    
                    if vm.movie!.originalTitle != vm.movie!.title {
                        Text(vm.movie!.title)
                            .font(.title)
                            .lineLimit(1)
                    }
                    
                    Text("\"\(vm.movie!.tagline ?? "")\"")
                        .opacity(0.7)
                        .font(.title2)
                        .lineLimit(1)
                    
                    HStack {
                        Text(vm.movie!.releaseDate?.getString(format: "MMM d, yyyy") ?? "-")
                            .lineLimit(1)

                        Image(systemName: "rhombus.fill")

                        ForEach(vm.movie!.genres, id: \.self.id) { genre in
                            GenreTagView(genre: genre.name)
                        }

                        Image(systemName: "rhombus.fill")

                        Text(vm.movie!.runtime?.minutesToHoursAndMinutes() ?? "")
                            .lineLimit(1)
                    }

                    HStack {
                        VoteProgressView(value: vm.movie!.voteAverage)
                        
                        if vm.movie!.trailerURL != nil {
                            playTrailerButton()
                                .padding(.leading, 40)
                        }
                    }
                    
                    HStack {
                        if vm.movie!.homepage != nil && vm.movie!.homepage != "" {
                            Button(action: {
                                let url = URL(string: vm.movie!.homepage!) ?? URL(string: "google.com")!
                                NSWorkspace.shared.open(url)
                            }) {
                                Label("Visit Movie Webstie", systemImage: "globe")
                            }
                            .buttonStyle(.borderless)
                            .onHover { hovering in
                                changeNSCursor(to: .pointingHand, for: hovering)
                            }
                        }
                        
                        if vm.movie!.imdbID != "" {
                            Button(action: {
                                let url = URL(string: vm.movie!.imdbID) ?? URL(string: "google.com")!
                                NSWorkspace.shared.open(url)
                            }) {
                                Label("IMDb", systemImage: "globe")
                            }
                            .buttonStyle(.borderless)
                            .onHover { hovering in
                                changeNSCursor(to: .pointingHand, for: hovering)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Overview")
                    .fontWeight(.semibold)
                
                Text(vm.movie!.overview ?? "")
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Production Companies")
                    .fontWeight(.semibold)
                
                HStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(vm.movie!.productionCompanies, id: \.self.id) { company in
                                VStack {
                                    AsyncImage(url: URL(string: company.logoUrl) ?? URL(string: "")) { img in
                                        img
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                         Image(systemName: "photo")
                                            .font(.largeTitle)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(company.name)
                                }
                                .padding()
                                .font(.caption)
                                .frame(width: 100, height: 130)
                                .background(VisualEffect(material: .hudWindow, blendingMode: .withinWindow))
                                .cornerRadius(7)
                            }
                        }
                    }
                    
                    Image(systemName: "chevron.right")
                }
            }
            
            Spacer()
        }
        .padding(.leading, Sizes.sidebarShrunk)
        .padding(.leading)
        .padding(.bottom)
        .padding(.horizontal)
        .padding(.top, 70)
    }
    
    // play trailer button
    func playTrailerButton() -> some View {
        Label("Play Trailer", systemImage: "play.rectangle.on.rectangle.fill")
            .font(.title2)
    }
    
    // big poster background
    func bigPosterBackground() -> some View {
        vm.showingPosterImage ?
        Button(action: {
            withAnimation(.spring()) {
                vm.showingPosterImage = false
            }
        }) {
            VisualEffect(material: .popover, blendingMode: .withinWindow)
        }
            .buttonStyle(.borderless)
            .onHover { hovering in
                changeNSCursor(to: .pointingHand, for: hovering)
            }
        : nil
    }
}

//MARK: - misc sections
extension MovieDetailView {
    // horizontal scroll info
    func horizontalScrollInfo() -> some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Label {
                        Text("Adult: \(vm.movie!.adult ? "Yes" : "No")")
                    } icon: {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundColor(.red)
                    }
                    
                    Label {
                        Text("Budge: \(vm.movie!.budget.getCurrencyForamt() ?? "-")")
                    } icon: {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Label {
                        Text("Revenue: \(vm.movie!.revenue.getCurrencyForamt() ?? "-")")
                    } icon: {
                        Image(systemName: "banknote.fill")
                            .foregroundColor(.green)
                    }
                    
                    Label {
                        Text("Language: \(vm.movie!.originalLanguage.capitalized)")
                    } icon: {
                        Image(systemName: "globe.americas.fill")
                            .foregroundColor(.blue)
                    }
                }
                .symbolRenderingMode(.hierarchical)
                .font(.title2)
            }
            
            Image(systemName: "chevron.right")
        }
    }
}
