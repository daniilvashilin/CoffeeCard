import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = -1

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.10),
                Color.white.opacity(0.30),
                Color.white.opacity(0.10)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .rotationEffect(.degrees(10))
        .offset(x: phase * 220)
        .onAppear {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                phase = 1.5
            }
        }
    }
}
