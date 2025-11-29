import SwiftUI

struct CartPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "cart")
                    .font(.system(size: 40))
                    .padding(.bottom, 4)
                
                Text("Cart is not implemented yet")
                    .font(.headline)
                
                Text("Here you will see all items you've added.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundApp.ignoresSafeArea())
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
