import SwiftUI

struct AppRootView: View {
    @State private var showSplash: Bool = true
    @StateObject private var session = SessionViewModel()

    var body: some View {
        ZStack {
            RootView()
                .opacity(showSplash ? 0 : 1)
                .animation(.easeInOut(duration: 0.4), value: showSplash)

            if showSplash {
                SplashView(isVisible: $showSplash)
                    .transition(.opacity)
            }
        }
        .environmentObject(session)
    }
}
