import SwiftUI
import Lottie

struct SplashView: View {
    @Binding var isVisible: Bool

    @State private var circleScale: CGFloat = 1.0
    @State private var overlayOpacity: Double = 1.0

    var body: some View {
        ZStack {
            Color.buttonText
                .ignoresSafeArea()
                .opacity(overlayOpacity)

            Circle()
                .fill(Color.backgroundApp)
                .frame(width: 260, height: 260)
                .scaleEffect(circleScale)

            LottieView(animationName: "CoffeeLoader")
                .frame(width: 140, height: 140)
        }
        .onAppear {
            runAnimation()
        }
    }

    private func runAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.6)) {
                circleScale = 5.0
                overlayOpacity = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isVisible = false
            }
        }
    }
}


