//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var vm: SidebarViewModel
    
    var body: some View {
        HStack {
            VStack (spacing: 0) {
                ForEach(vm.sidebarButtons.indices, id: \.self) { i in
                    sideBarButtonView(i: i)
                }
                
                Spacer()
            }
            .frame(width: vm.isHoveringSidebar ? Sizes.sidebarExpanded : Sizes.sidebarShrunk)
            .background(VisualEffect(material: .popover, blendingMode: .withinWindow).ignoresSafeArea())
            .onHover { hover in
                withAnimation(.spring()) {
                    vm.isHoveringSidebar = hover
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}

extension SidebarView {
    func sideBarButtonView(i: Int) -> some View {
        let button = vm.sidebarButtons[i]
        
        return (
            Button(action: {
                vm.selectedView = i
            }) {
                HStack (spacing: vm.isHoveringSidebar ? 15 : 0) {
                    Image(systemName: button.icon)
                        .font(Sizes.fontSizeNavButtons)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: vm.isHoveringSidebar ? Sizes.sidebarExpanded * 0.3 : Sizes.sidebarShrunk, alignment: .center)
                        .padding(.leading, vm.isHoveringSidebar ? Sizes.sidebarExpanded * 0.3 * 0.5 : 0)
                        .foregroundColor(vm.selectedView == i ? Color(Colors.accent.rawValue) : Color.primary)
                    
                    Text(vm.isHoveringSidebar ? button.name : "")
                        .font(Sizes.fontSizeNavText)
                        .frame(width: vm.isHoveringSidebar ? Sizes.sidebarExpanded * 0.7 : 0, alignment: .leading)
                        .foregroundColor(.primary)
                }
            }
                .buttonStyle(.borderless)
                .padding(.top, 40)
                .onHover { hovering in
                    changeNSCursor(to: .pointingHand, for: hovering)
                }
        )
    }
}
