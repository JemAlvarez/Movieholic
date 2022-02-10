// backdrop image not staying at backdropheight

import SwiftUI

struct MovieDetailView: View {
    @Namespace var animation
    @EnvironmentObject var router: Router
    let id: Int
    
    @StateObject var vm = MovieDetailViewModel()
    
    var movie: MovieModel? {
        vm.movie
    }
    
    var body: some View {
        ZStack {
            content()
                .overlay(bigPosterBackground())
            
            if vm.showingPosterImage {
                posterImage(small: false)
            }
        }
        .foregroundColor(.primary)
        .ignoresSafeArea()
        .task {
            await vm.fetch(for: id)
        }
    }
}

//MARK: - big components
extension MovieDetailView {
    // whole content
    func content() -> some View {
        ScrollView {
            VStack {
                heroSection()
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

//MARK: - small components
extension MovieDetailView {
    // small poster
    func posterImage(small: Bool = true) -> some View {
        VStack {
            AsyncImage(url: URL(string: movie?.posterURL ?? "")) { img in
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
        .padding()
        .frame(width: small ? Sizes.mediaCardSize.width : Sizes.mediaCardSize.width * 2, height: small ? Sizes.mediaCardSize.height : Sizes.mediaCardSize.height * 2)
    }
    
    // backdrop image
    func backdropImg() -> some View {
        GeometryReader{ geo in
            VStack {
                AsyncImage(url: URL(string: movie?.backdropURL ?? "")) { img in
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
        HStack {
            posterImage()
            
            Spacer()
        }
        .padding(.leading, Sizes.sidebarShrunk)
        .padding(.bottom)
        .padding(.horizontal)
        .padding(.top, 100)
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
