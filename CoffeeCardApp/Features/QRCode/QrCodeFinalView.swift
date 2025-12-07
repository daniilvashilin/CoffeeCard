import SwiftUI

struct QrCodeFinalView: View {
    @Binding var isTabBarHidden: Bool
    @State private var activeSheet: ActiveSheet?
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        Button {
            if session.isSignedIn {
                activeSheet = .contentShow
            } else {
                activeSheet = .loginNeeded
            }
        } label: {
            QrCodeButtonView(
                state: session.isSignedIn ? .contentShow : .loginNeeded
            )
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .contentShow:
                QrDetailView()
                    .environmentObject(session)
            case .loginNeeded:
                NavigationStack {
                    LoginView(isTabBarHidden: $isTabBarHidden)
                }
            }
        }
        
        .onChange(of: activeSheet) { _, newValue in
            withAnimation {
                isTabBarHidden = (newValue != nil)
            }
        }
    }
}

struct QrCodeButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    let state: ActiveSheet
    
    var body: some View {
        switch state {
        case .contentShow:
            let animationName = "qrCode"
            ZStack {
                RoundedRectangle(cornerRadius: 18.ds)
                    .fill(Color.primaryText)
                    .frame(width: 180.ds, height: 180.ds)
                    .clipShape(RoundedRectangle(cornerRadius: 18.ds))
                LottieView(animationName: animationName)
                    .id(animationName)
                    .frame(width: 120.ds, height: 120.ds)
            }
        case .loginNeeded:
            ZStack {
                RoundedRectangle(cornerRadius: 18.ds)
                    .fill(Color.primaryText.opacity(0.4))
                
                Image(systemName: "qrcode")
                    .resizable()
                    .frame(width: 100.ds, height: 100.ds)
                    .foregroundStyle(.primaryText)
                    .opacity(0.4)
                
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.primaryText)
            }
            .frame(width: 180.ds, height: 180.ds)
        }
    }
}
