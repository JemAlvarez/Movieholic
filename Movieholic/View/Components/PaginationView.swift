//

import SwiftUI

struct PaginationView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack {
            // previous button
            
            ForEach(0..<10) { pageNum in
                // if current - 2 is > 0
                    // show current - 2 to current + 3
                // else
                    // show 1 to 6
                
                Button(action: {
                    currentPage = pageNum + 1
                }) {
                    Text("\(pageNum + 1)")
                        .foregroundColor(currentPage == pageNum + 1 ? Color(Colors.accent.rawValue) : .primary)
                }
                .buttonStyle(.borderless)
            }
            
            // show "..."
            
            // show last button
            
            // next button
        }
        .padding(.vertical, 40)
    }
}

