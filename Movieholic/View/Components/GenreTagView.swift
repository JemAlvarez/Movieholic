//

import SwiftUI

struct GenreTagView: View {
    let genre: String
    
    var body: some View {
        Text(genre)
            .fontWeight(.medium)
            .lineLimit(1)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .foregroundColor(Color(Colors.accent.rawValue))
            .background(
                RoundedCornerRectangleShape(radius: 0.4)
                    .fill(Color(.black).opacity(0.5))
            )
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreTagView(genre: "Fantasy")
    }
}
