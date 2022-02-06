//

import SwiftUI

struct PaginationView: View {
    @Binding var currentPage: Int // currentpage from view model to change and fetch data on change
    let totalPages: Int // total pages for the category
    
    @State var hoveringPrevious = false
    @State var hoveringNext = false
    
    var lastPage: Int { // last page computed property to not be over 500
        totalPages > 500 ? 500 : totalPages
    }
    
    var body: some View {
        HStack {
            // previous button
            endsButtons(next: false)
            
            HStack(spacing: 0) {
                // show first button
                Button(action: {
                    withAnimation {
                        currentPage = 1
                    }
                }) {
                    Text("1")
                        .frame(width: 40, height: 40)
                        .background(currentPage == 1 ? Color(Colors.accent.rawValue) : .clear)
                        .cornerRadius(5)
                }
                .buttonStyle(.borderless)
                .onHover { hovering in
                    changeNSCursor(to: .pointingHand, for: hovering)
                }
                
                // there are more than 7 pages ...  show all pages
                if lastPage > 7 {
                    if currentPage <= 5 { // if current page is between 1 and 5
                        // dont include 1st page and show the first 8
                        ForEach(2..<8) { i in
                            pageButton(i: i)
                        }
                        
                        ellipsisButton()
                    } else if currentPage >= lastPage - 5 { // if current page is between last and 5 less than last
                        ellipsisButton()
                        
                        // dont inlcude last
                        ForEach(lastPage - 7..<lastPage) { i in
                            pageButton(i: i)
                        }
                    } else {
                        ellipsisButton()
                        
                        // show current and the 3 surrounding
                        ForEach(currentPage - 3...currentPage + 3, id: \.self) { i in
                            pageButton(i: i)
                        }
                        
                        ellipsisButton()
                    }
                } else {
                    // show all pages .. not inlcuding 1st and last
                    ForEach(2..<lastPage) { i in
                        pageButton(i: i)
                    }
                }
                
                // show last button
                Button(action: {
                    withAnimation {
                        currentPage = lastPage
                    }
                }) {
                    Text("\(lastPage)")
                        .frame(width: 40, height: 40)
                        .background(currentPage == lastPage ? Color(Colors.accent.rawValue) : .clear)
                        .cornerRadius(5)
                }
                .buttonStyle(.borderless)
                .onHover { hovering in
                    changeNSCursor(to: .pointingHand, for: hovering)
                }
            }
            .padding(.horizontal, 20)
            .background(
                // background for the pages number
                    // clip background because clipping whole stack makes buttons not clickable
                VisualEffect(material: .hudWindow, blendingMode: .behindWindow)
                            .clipShape(RoundedRectangle(cornerRadius: 99, style: .continuous))
            )
            
            // next button
            endsButtons(next: true)
        }
        .foregroundColor(.primary)
        .padding(.vertical, 40)
        .font(.system(size: 17, weight: .semibold))
    }
}

extension PaginationView {
    // previous/next button
    func endsButtons(next: Bool) -> some View {
        Button(action: {
            withAnimation {
                if next { // if next
                    // add 1 if not going over the last page
                    if currentPage < lastPage {
                        currentPage = currentPage + 1
                    }
                } else { // opposite
                    if currentPage > 1 {
                        currentPage = currentPage - 1
                    }
                }
            }
        }) {
            Image(systemName: next ? "chevron.right" : "chevron.left")
                .padding()
        }
        .buttonStyle(.borderless)
        .foregroundColor(
            // if next
            next ? (
                // if hovering next
                hoveringNext ? .primary : Color(Colors.accent.rawValue)
            ) :
           // else
            //if hovering previous
            hoveringPrevious ? .primary : Color(Colors.accent.rawValue)
        )
        // two background to siwtch between color and visula effect
        .background(
            // if next
            next ? (
                // if hovring next
                hoveringNext ? nil : VisualEffect(material: .hudWindow, blendingMode: .behindWindow)
                    .clipShape(Circle())
            ) :
           // else
            //if hovering previoous
            hoveringPrevious ? nil : VisualEffect(material: .hudWindow, blendingMode: .behindWindow)
                .clipShape(Circle())
        )
        .background(
            // if next
            next ? (
                // if hovring next
                hoveringNext ? Color(Colors.accent.rawValue)
                    .clipShape(Circle()) : nil
            ) :
           // else
            //if hovering previoous
            hoveringPrevious ? Color(Colors.accent.rawValue)
                .clipShape(Circle()) : nil
        )
        .onHover { hovering in
            withAnimation {
                if next {
                    hoveringNext = hovering
                } else {
                    hoveringPrevious = hovering
                }
            }
            
            changeNSCursor(to: .pointingHand, for: hovering)
        }
    }
    
    // page buttons
    func pageButton(i: Int) -> some View {
        Button(action: {
            withAnimation {
                currentPage = i // set to i
            }
        }) {
            Text("\(i)")
                .frame(width: 40, height: 40)
                .background(currentPage == i ? Color(Colors.accent.rawValue) : .clear)
                .cornerRadius(5)
        }
        .buttonStyle(.borderless)
        .onHover { hovering in
            changeNSCursor(to: .pointingHand, for: hovering)
        }
    }
    
    func ellipsisButton() -> some View {
        Image(systemName: "ellipsis")
    }
}
