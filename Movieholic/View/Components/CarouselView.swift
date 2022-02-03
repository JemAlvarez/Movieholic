//

import SwiftUI
import ACarousel

struct CarouselView: View {
    let data: FeaturedModelBase?
    
    var body: some View {
        VStack {
            if data != nil {
                ACarousel(
                    data!.results,
                    spacing: 0,
                    headspace: 0,
                    sidesScaling: 0,
                    isWrap: true,
                    autoScroll: .active(15)
                ) { item in
                    
                    mediaView(item: item)
                    
                }
                .frame(height: 700)
                .ignoresSafeArea()
            }
        }
        .frame(height: 700)
        .background(VisualEffect(material: .menu, blendingMode: .behindWindow))
    }
}

extension CarouselView {
    func mediaView(item: FeaturedModel) -> some View {
        ZStack {
            AsyncImage(url: URL(string: item.backdropUrl ?? "")) { img in
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "photo.on.rectangle.angled")
                   .font(.largeTitle)
            }
            
            GeometryReader { geo in
                VStack {
                    HStack {
                        ForEach(item.genres, id: \.self) { genre in
                            GenreTagView(genre: genre)
                        }
                    }
                    
                    HStack {
                        Text(item.movieTitle!)
                            .font(.largeTitle)
                        
                        
                    }
                    
                    Text(item.overview)
                        .multilineTextAlignment(.leading)
                }
                .frame(width: geo.size.width * 0.8)
            }
        }
    }
}
