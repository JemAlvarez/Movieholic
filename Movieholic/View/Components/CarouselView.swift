//

import SwiftUI
struct CarouselView: View {
    @State var timer = Timer.publish(every: 12, on: .main, in: .common).autoconnect() // timer to auto scroll
    @State var currentPageNum = 0
    
    let numButtons: Int
    @State var items: [MediaModel] // items
    
    @State var hoveringPrevious = false
    @State var hoveringNext = false
    
    init(items: [MediaModel]) {
        self.items = items
        self.numButtons = items.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            content()
            
            // pagination
            pagination()
        }
        .foregroundColor(.primary)
        .onReceive(timer) { input in    // timer for autoscrolling
            nextPage()
        }
    }
}

//MARK: - views extensions
extension CarouselView {
    func content() -> some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(items) { item in
                    CarouselCardView(item: item)
                        .frame(width: geo.size.width) // window width
                }
            }
            .offset(x: -geo.size.width) // offset to second item so the wrapping of the items is not noticeable
        }
        .frame(height: Sizes.backdropHeight) // carousel height
        .background(VisualEffect(material: .menu, blendingMode: .behindWindow)) // material backgroud visible when images loading
    }
    
    func pagination() -> some View {
        HStack{
            Button(action: {
                previousPage()
                restartTimer()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(hoveringPrevious ? .primary : Color(Colors.accent.rawValue))
                    .frame(width: 40, height: 40)
                    .background(hoveringPrevious ? nil : VisualEffect(material: .hudWindow, blendingMode: .behindWindow))
                    .background(hoveringPrevious ? Color(Colors.accent.rawValue) : nil)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
            .padding(.leading, Sizes.sidebarShrunk)
            .onHover { hovering in
                withAnimation {
                    hoveringPrevious = hovering
                }
                
                changeNSCursor(to: .pointingHand, for: hovering)
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<numButtons) {i in
                    RoundedRectangle(cornerRadius: 99)
                        .frame(width: currentPageNum == i ? 14 : 7, height: 7)
                        .foregroundColor(currentPageNum == i ? Color(Colors.accent.rawValue) : .primary)
                }
            }
            .offset(x: Sizes.sidebarShrunk / 2) // center horizontal due to the sidebar
            
            Spacer()
            
            Button(action: {
                nextPage()
                restartTimer()
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(hoveringNext ? .primary : Color(Colors.accent.rawValue))
                    .frame(width: 40, height: 40)
                    .background(hoveringNext ? nil : VisualEffect(material: .hudWindow, blendingMode: .behindWindow))
                    .background(hoveringNext ? Color(Colors.accent.rawValue) : nil)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
            .onHover { hovering in
                withAnimation {
                    hoveringNext = hovering
                }
                
                changeNSCursor(to: .pointingHand, for: hovering)
            }
        }
        .padding(.horizontal)
    }
}


//MARK: - funcs extensions
extension CarouselView {
    func nextPage() {
        if let item = items.first { // if items has a first item (not empty)
            withAnimation(.spring()) {
                let _ = items.removeFirst() // remove the first item
            }
            
            items.append(item) // append the item to the back (no animation because it causes a weird visual bug)
        }
        
        // pagination
        let nextPageNum = currentPageNum + 1
        
        withAnimation(.spring()) {
            if nextPageNum < numButtons { // if not last page
                currentPageNum = nextPageNum // go to next page
            } else { // else
                currentPageNum = 0 // go to begining
            }
        }
    }
    
    func previousPage() {
        let item = items.removeLast() // remove the last item
        withAnimation(.spring()) {
            items.insert(item, at: 0) // insert at the begining
        }
        
        // pagination
        let previousPageNum = currentPageNum - 1
        
        withAnimation(.spring()) {
            if previousPageNum >= 0 { // if not first page
                currentPageNum = previousPageNum // go to previous page
            } else { // else
                currentPageNum = items.count - 1 // go to end
            }
        }
    }
    
    func restartTimer() {
        timer = Timer.publish(every: 12, on: .main, in: .common).autoconnect() // timer to auto scroll
    }
}
