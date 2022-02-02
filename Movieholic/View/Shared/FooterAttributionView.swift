//

import SwiftUI

struct FooterAttributionView: View {
    var body: some View {
        HStack (spacing: 20) {
            Text("Powered by:")
                .font(.largeTitle)
            
            Image("tmdb")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .frame(height: 150)
    }
}

struct FooterAttributionView_Previews: PreviewProvider {
    static var previews: some View {
        FooterAttributionView()
    }
}
