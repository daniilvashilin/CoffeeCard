import SwiftUI

struct HeaderView: View {
    @EnvironmentObject private var session: SessionViewModel
    @State private var activeSheet: ActiveSheet?
    
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
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .contentShow:
                CoinsInfoView(state: viewModel.coinsState)
            case .loginNeeded:
                NavigationStack {
                    LoginView(isTabBarHidden: .constant(true))
                }
            }
        }
    }
    
    private func handleTap() {
        if viewModel.isSignedIn {
            activeSheet = .contentShow
        } else {
            activeSheet = .loginNeeded
        }
    }
}

#Preview {
    HeaderView()
}



