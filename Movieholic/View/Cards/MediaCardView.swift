//

import SwiftUI

struct MediaCardView: View {
    var item: FeaturedModel
    @State var hovering = false
    
    var body: some View {
        VStack {
            ZStack {
                image()
                
                voteGuague()
            }
            .frame(height: Sizes.mediaCardSize.height)
            .background(
                VisualEffect(material: .menu, blendingMode: .behindWindow)
                    .cornerRadius(13)
            )
            .onHover { hovering in
                self.hovering = hovering
                changeNSCursor(to: .pointingHand, for: hovering)
            }
            
            info()
        }
        .frame(width: Sizes.mediaCardSize.width)
    }
}

extension MediaCardView {
    func image() -> some View {
        AsyncImage(url: URL(string: item.posterUrl ?? "")) { img in
            img
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.95)
                .cornerRadius(13)
        } placeholder: {
             Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
        }
    }
    
    func voteGuague() -> some View {
        ProgressView(value: item.voteAverage, total: 10)
            .progressViewStyle(GaugeProgressStyle(strokeColor: Color(Colors.accent.rawValue), strokeWidth: 6, size: (35, 35), filledBackground: true, backgroundColor: Color(Colors.accentDark.rawValue)))
            .tint(Color(Colors.accent.rawValue))
            .overlay(
                Text(item.voteAverage == 0 ? "NR" : "\((item.voteAverage / 10) * 100, specifier: "%.0f")%")
                    .font(.caption)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing) // take the whole available space and align top right
            .offset(x: 5, y: -10) // offset a little
    }
    
    func info() -> some View {
        VStack {
            Group {
                if item.movieTitle != nil {
                    Text(item.movieTitle!)
                } else if item.tvName != nil {
                    Text(item.tvName!)
                }
            }
            .padding(.leading, 15)
            .foregroundColor(hovering ? Color(Colors.accent.rawValue) : .primary)
            .font(.title3)
            .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
