//

import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var router: Router
    let id: Int
    
    var body: some View {
        VStack {
            VStack {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/bOcgTLEMgWu0pDhUhxR5xa6tAm5.jpg")) { img in
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
            .frame(width: Sizes.mediaCardSize.width, height: Sizes.mediaCardSize.height)
            
            Text("\(id)")
            
            Button(action: {
                router.pop()
            }) {
                Text("Go back")
            }
        }
    }
}
