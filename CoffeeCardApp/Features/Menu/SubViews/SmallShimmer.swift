import SwiftUI

struct SmallShimmerDiagonal: View {
    @State private var move: CGFloat = -1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.15))
            .overlay(
                // Диагональная полоса
                LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0.0),
                        .white.opacity(0.35),
                        .white.opacity(0.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 50, height: 120)  // узкая, вытянутая диагональ
                .rotationEffect(.degrees(20))   // лёгкий угол для красоты
                .offset(x: move * 120, y: move * 120) // двигаем по диагонали
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    move = 1.0
                }
            }
    }
}
