//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var vm: SidebarViewModel
    
    var body: some View {
        HStack {
            VStack (spacing: 0) {
                ForEach(vm.sidebarButtons.indices, id: \.self) { i in
                    if i != vm.sidebarButtons.count - 1 {
                        sideBarButtonView(i: i)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        vm.sidebarExpanded.toggle()
                    }
                }) {
                    HStack (spacing: vm.sidebarExpanded ? 15 : 0) {
                        Image(systemName: vm.sidebarButtons.last?.icon ?? "")
                            .font(Sizes.fontSizeNavButtons)
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.3 : Sizes.sidebarShrunk, alignment: .center)
                            .padding(.leading, vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.3 * 0.5 : 0)
                        
                        Text(vm.sidebarExpanded ? vm.sidebarButtons.last?.name ?? "" : "")
                            .font(Sizes.fontSizeNavText)
                            .frame(width: vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.7 : 0, alignment: .leading)
                            .foregroundColor(.primary)
                    }
                }
                    .buttonStyle(.borderless)
                    .padding(.bottom, 50)
                    .foregroundColor(.primary)
                    .onHover { hovering in
                        changeNSCursor(to: .pointingHand, for: hovering)
                    }
            }
            .frame(width: vm.sidebarExpanded ? Sizes.sidebarExpanded : Sizes.sidebarShrunk)
            .background(VisualEffect(material: .popover, blendingMode: .withinWindow).ignoresSafeArea())
            
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
                HStack (spacing: vm.sidebarExpanded ? 15 : 0) {
                    Image(systemName: button.icon)
                        .font(Sizes.fontSizeNavButtons)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.3 : Sizes.sidebarShrunk, alignment: .center)
                        .padding(.leading, vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.3 * 0.5 : 0)
                        .foregroundColor(vm.selectedView == i ? Color(Colors.accent.rawValue) : Color.primary)
                    
                    Text(vm.sidebarExpanded ? button.name : "")
                        .font(Sizes.fontSizeNavText)
                        .frame(width: vm.sidebarExpanded ? Sizes.sidebarExpanded * 0.7 : 0, alignment: .leading)
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
