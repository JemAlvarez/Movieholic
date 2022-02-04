//

import SwiftUI
struct CarouselView: View {
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    @State var items: [FeaturedModel]
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        CarouselCardView(item: item)
                            .frame(width: geo.size.width)
                    }
                }
                .offset(x: -geo.size.width * 1)
            }
            .frame(height: Sizes.carouselHeight)
            .background(VisualEffect(material: .menu, blendingMode: .behindWindow))
            .onReceive(timer) { input in
                if let item = items.first {
                    withAnimation(.spring()) {
                        let _ = items.removeFirst()
                    }
                    
                    items.append(item)
                }
            }
            
            Text("BUTTONS")
        }
    }
}
