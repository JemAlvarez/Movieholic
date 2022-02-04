//

import SwiftUI

struct FeaturedRowView: View {
    let data: FeaturedModelBase?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    if data != nil {
                        ForEach(data!.results.indices) { i in
                            if let item = data!.results[i] {
                                MediaCardView(item: item)
                                    .padding(.leading, i == 0 ? Sizes.leftPaddingSidebarShrunk : 0)
                            }
                        }
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                    }
                }
                .padding(.vertical, 15) // padding so it doesnt clip the vote guague
            }
        }
    }
}
