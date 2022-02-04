//

import SwiftUI

struct CarouselCardView: View {
    let item: FeaturedModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                splashImage(geo: geo)
                
                info(geo: geo)
            }
            .frame(height: Sizes.carouselHeight)
        }
    }
}

extension CarouselCardView {
    func splashImage(geo: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: item.backdropUrl ?? "")) { img in
            img
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: Sizes.carouselHeight)
                .clipped()
                .opacity(0.7)
        } placeholder: {
            Image(systemName: "photo.on.rectangle.angled")
               .font(.largeTitle)
               .offset(y: -200)
        }
    }
    
    func info(geo: GeometryProxy) -> some View {
        VStack { // take whole carousel
            Spacer() // move down
            
            HStack { // hstakc view to move to the left
                VStack(alignment: .leading, spacing: 20) { // vertically stacked info
                    HStack {
                        ForEach(item.genres, id: \.self) { genre in
                            GenreTagView(genre: genre)
                        }
                        
                        Spacer()
                        
                        VoteProgressView(value: item.voteAverage)
                    }
                    
                    HStack {
                        Text(item.movieTitle!)
                            .font(.largeTitle)
                    }
                    
                    Text(item.overview)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                }
                .padding(.horizontal, Sizes.leftPaddingSidebarShrunk) // padding past the sidebar
                .padding(.vertical, Sizes.leftPaddingSidebarShrunk - Sizes.sidebarShrunk) // vertical padding (math makes it seem the same as padding on th left)
                .frame(width: Sizes.minWidth) // minimum width is the same as the minimum window winth
                .background(
                    VisualEffect(material: .fullScreenUI, blendingMode: .withinWindow) // material background
                                .blur(radius: 30) // blur the edges
                )
                
                Spacer() // move left
            }
        }
        .frame(width: geo.size.width) // window width
        .clipped() // clip blur on the bottom
    }
}
