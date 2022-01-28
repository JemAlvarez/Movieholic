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
            .frame(width: vm.hovering ? Sizes.sidebarExpanded : Sizes.sidebarShrunk)
            .background(VisualEffect(material: .popover, blendingMode: .withinWindow).ignoresSafeArea())
            .onHover { hover in
                withAnimation(.spring()) {
                    vm.hovering = hover
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
                HStack (spacing: vm.hovering ? 15 : 0) {
                    Image(systemName: button.icon)
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: vm.hovering ? Sizes.sidebarExpanded * 0.3 : Sizes.sidebarShrunk, alignment: .center)
                        .padding(.leading, vm.hovering ? Sizes.sidebarExpanded * 0.3 * 0.5 : 0)
                        .foregroundColor(vm.selectedView == i ? Color(Colors.accent.rawValue) : Color.primary)
                    
                    Text(vm.hovering ? button.name : "")
                        .font(.title3)
                        .frame(width: vm.hovering ? Sizes.sidebarExpanded * 0.7 : 0, alignment: .leading)
                }
            }
                .buttonStyle(.borderless)
                .padding(.top, 40)
        )
    }
}
