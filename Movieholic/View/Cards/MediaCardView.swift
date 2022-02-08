//

import SwiftUI

struct MediaCardView: View {
    @EnvironmentObject var router: Router
    
    var item: MediaModel
    
    @State var hovering = false
    
    var body: some View {
        Button(action: {
            if item.peopleName != nil {
                router.push(.people(id: item.id))
            } else if item.tvName != nil {
                router.push(.tv(id: item.id))
            } else if item.movieTitle != nil {
                router.push(.movie(id: item.id))
            }
        }) {
            VStack {
                ZStack {
                    image()
                    
                    if item.peopleName == nil { // if its not a people fetch
                        voteProgress()
                    }
                }
                .frame(width: Sizes.mediaCardSize.width, height: Sizes.mediaCardSize.height)
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
            .padding([.top, .trailing], 15)
        }
        .buttonStyle(.borderless)
    }
}

extension MediaCardView {
    func image() -> some View {
        AsyncImage(url:
                    // if people
                   item.peopleName != nil ? URL(string: item.peopleProfileURL ?? "") :
                    URL(string: item.posterUrl ?? "")
        ) { img in
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
        VoteProgressView(value: item.voteAverage ?? 0)
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
                } else if item.peopleName != nil {
                    Text(item.peopleName!)
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
