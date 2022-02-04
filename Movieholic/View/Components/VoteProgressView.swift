//

import SwiftUI

struct VoteProgressView: View {
    let value: Double
    
    var body: some View {
        ProgressView(value: value, total: 10)
            .progressViewStyle(GaugeProgressStyle(strokeColor: Color(Colors.accent.rawValue), strokeWidth: 6, size: (35, 35), filledBackground: true, backgroundColor: Color(Colors.accentDark.rawValue)))
            .tint(Color(Colors.accent.rawValue))
            .overlay(
                Text(value == 0 ? "NR" : "\((value / 10) * 100, specifier: "%.0f")%")
                    .font(.caption)
            )
    }
}
