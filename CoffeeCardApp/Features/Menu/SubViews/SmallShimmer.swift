import SwiftUI

struct SmallShimmerDiagonal: View {
    @State private var move: CGFloat = -1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.15))
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0.0),
                        .white.opacity(0.35),
                        .white.opacity(0.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 50, height: 120)
                .rotationEffect(.degrees(20))
                .offset(x: move * 120, y: move * 120) 
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    move = 1.0
                }
            }
    }
}
