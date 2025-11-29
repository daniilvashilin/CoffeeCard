import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backgroundApp)
            .ignoresSafeArea()
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}
