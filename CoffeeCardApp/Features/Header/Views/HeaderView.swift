import SwiftUI

struct HeaderView: View {
    @EnvironmentObject private var session: SessionViewModel
    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case coinsInfo
        case login
        
        var id: Int {
            switch self {
            case .coinsInfo: return 0
            case .login:     return 1
            }
        }
    }
    
    private var viewModel: HeaderViewModel {
        HeaderViewModel(user: session.user)
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                handleTap()
            } label: {
                CoinsBalanceView(state: viewModel.coinsState)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .coinsInfo:
                CoinsInfoView()
            case .login:
                NavigationStack {
                    LoginView(isTabBarHidden: .constant(true))
                }
            }
        }
    }
    
    private func handleTap() {
        if viewModel.isSignedIn {
            activeSheet = .coinsInfo
        } else {
            activeSheet = .login
        }
    }
}

#Preview {
    HeaderView()
}



