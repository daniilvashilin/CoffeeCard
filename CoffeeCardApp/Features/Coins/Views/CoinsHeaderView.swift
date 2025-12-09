import SwiftUI

struct CoinsInfoHeaderView: View {
    let onToggleNotifications: () -> Void

    var body: some View {
        HStack {
            Text("Rewards")
                .font(.title.bold())
                .foregroundStyle(.primaryText)
            Spacer()
            Button(action: onToggleNotifications) {
                Image(systemName: "bell")
                    .font(.title2.bold())
                    .foregroundStyle(.accentApp)
            }
        }
        .padding()
    }
}
