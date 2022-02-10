// backdrop image not staying at backdropheight

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var router: Router
    let id: Int
    
    @StateObject var vm = MovieDetailViewModel()
    
    var movie: MovieModel? {
        vm.movie
    }
    
    var body: some View {
        ZStack {
            windowSize()
            
            content()
        }
        .foregroundColor(.primary)
        .ignoresSafeArea()
        .task {
            await vm.fetch(for: id)
        }
    }
}

extension MovieDetailView {
    func content() -> some View {
        ScrollView {
            VStack {
                heroSection()
            }
            .padding(.leading, Sizes.sidebarShrunk)
            .padding()
        }
    }
    
    func heroSection() -> some View {
        ZStack(alignment: .top) {
            backdropImg()
            
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
        }
        .frame(height: Sizes.backdropHeight)
        .ignoresSafeArea()
    }
    
    func backdropImg() -> some View {
        VStack {
            AsyncImage(url: URL(string: movie?.backdropURL ?? "")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle().fill(.secondary)
            }
        }
        .opacity(0.3)
        .frame(width: vm.windowSize.width)
        .padding(.leading, -Sizes.sidebarShrunk)
        .padding(-17)
    }
}

extension MovieDetailView {
    func windowSize() -> some View {
        getViewSize { width, height in
            vm.windowSize.width = width
            vm.windowSize.height = height
        }
    }
}
