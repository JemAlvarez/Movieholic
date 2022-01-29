//

import SwiftUI

struct SearchbarView: View {
    @StateObject var vm = SearchbarViewModel()
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer() // move right
                
                if vm.showingBar {
                    barView() // search bar
                }
                
                toggleSearchbarButton() // toggle searchbar
            }
            
            Spacer() // move up
        }
        .padding()
        .ignoresSafeArea()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchbarView()
    }
}

extension SearchbarView {
    func toggleSearchbarButton() -> some View {
        Button(action: {
            if vm.showingBar { // if its shown, to remove
                // shrink bar
                withAnimation(.spring()) {
                    vm.searchbarWidth = 0
                }
                // delay removing from view
                withAnimation(.default.delay(0.1)) {
                    vm.showingBar.toggle()
                    vm.searchQuery = ""
                }
            } else { // not shown, to show
                // bring to view
                withAnimation() {
                    vm.showingBar.toggle()
                }
                // expand bar
                withAnimation(.spring().delay(0.1)) {
                    vm.searchbarWidth = Sizes.searchbarWidth
                }
            }
        }) {
            Image(systemName: vm.showingBar ? "xmark" : "text.magnifyingglass")
                .symbolRenderingMode(.hierarchical)
                .font(Sizes.fontSizeNavButtons)
                .foregroundColor(vm.isHoveringToggleButton ? (
                    vm.showingBar ? Color.red.opacity(0.7) : Color(Colors.accent.rawValue).opacity(0.7)
                ) : .primary)
        }
        .buttonStyle(.borderless)
        .padding(.vertical, 5)
        .onHover { hovering in
            changeNSCursor(to: .pointingHand, for: hovering)
            vm.isHoveringToggleButton = hovering
        }
    }
}


extension SearchbarView {
    func barView() -> some View {
        ZStack(alignment: .trailing) {
            // text field
            TextField("", text: $vm.searchQuery)
                .textFieldStyle(.plain)
                .frame(width: vm.searchbarWidth)
                .padding(.vertical, 5) // vertical padding
                .padding(.trailing, 20) // horizontal padding
                .padding(.leading, 30) // make space for magnifying glass icon
                .background(RoundedRectangle(cornerRadius: 99, style: .continuous).fill(Color.secondary.opacity(0.4)))
                .foregroundColor(Color(Colors.accent.rawValue))
            
            ZStack {
                // placehodler text
                if vm.searchQuery.isEmpty {
                    Text("Search")
                        .frame(width: Sizes.searchbarWidth, alignment: .leading)
                        .padding(.leading, 10)
                        .foregroundColor(Color(Colors.accent.rawValue).opacity(0.7))
                }
                
                // magnifying glass icon and cancel button
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            vm.searchQuery = ""
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(vm.isHoveringClearButton ? Color.red : Color.primary)
                    }
                    .buttonStyle(.borderless)
                    .onHover { hovering in
                        changeNSCursor(to: .pointingHand, for: hovering)
                        vm.isHoveringClearButton = hovering
                    }
                }
                .opacity(0.5)
                .frame(width: Sizes.searchbarWidth * 1.15)
            }
            .padding(.trailing, 10)
        }
    }
}
