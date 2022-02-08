//

import SwiftUI

struct MediaCardView: View {
    var item: MediaModel
    @State var hovering = false
    
    var body: some View {
        VStack {
            ZStack {
                image()
                
                voteProgress()
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
    
    func voteProgress() -> some View {
        VoteProgressView(value: item.voteAverage)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing) // take the whole available space and align top right
            .offset(x: 5, y: -10) // offset a little
    }
    
    func info() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Group {
                if item.movieTitle != nil {
                    Text(item.movieTitle!)
                    
                    Text(item.releaseDate?.getString(format: "MMM d, yyyy") ?? "-")
                        .font(.subheadline)
                        .opacity(0.7)
                } else if item.tvName != nil {
                    Text(item.tvName!)
                    
                    Text(item.firstAirDate?.getString(format: "MMM d, yyyy") ?? "-")
                        .font(.subheadline)
                        .opacity(0.7)
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
