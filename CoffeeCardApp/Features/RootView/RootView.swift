import SwiftUI

struct RootView: View {
    @State private var selection: CustomTabModel = .home
    private let tabs = CustomTabModel.allCases
    @StateObject private var promoViewModel =
    PromoViewModel(repository: FirestorePromoRepository())
    @State private var isTabHidden: Bool = false
    var body: some View {
        ZStack {
            Group {
                switch selection {
                case .home:
                    HomeView(promoViewModel: promoViewModel)
                case .Menu:
                    MenuView(isTabBarHidden: $isTabHidden)
                case .profile:
                    UserSettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundApp)
            .ignoresSafeArea(edges: .bottom)
            if !isTabHidden {
                VStack { Spacer() }
                    .safeAreaInset(edge: .bottom) {
                        GeometryReader { proxy in
                            let w = proxy.size.width - 24
                            CustomTabView(
                                width: w,
                                selection: $selection,
                                tabs: tabs
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 8)
                        }
                        .frame(height: 64 + 8)
                    }
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
            }
        }
        .animation(
            .spring(
                response: 0.30,
                dampingFraction: 0.85,
                blendDuration: 0
            ),
            value: isTabHidden
        )
    }
}

#Preview {
    RootView()
}
