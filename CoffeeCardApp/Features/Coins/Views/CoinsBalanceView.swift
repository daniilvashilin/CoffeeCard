import SwiftUI

enum CoinsBalanceState {
    case locked      // user not logged in
    case zero        // logged in, 0 coins
    case value(Int)  // logged in, > 0 coins
}

struct CoinsBalanceView: View {
    let state: CoinsBalanceState

    var body: some View {
        ZStack {
            if case .locked = state {
                RoundedRectangle(cornerRadius: 16.ds)
                    .fill(Color.primaryText.opacity(0.3))
            }

            HStack(spacing: 6) {
                if case .locked = state {
                    Image(systemName: "lock.fill")
                        .font(.headline)
                        .foregroundStyle(.primaryText)
                }

                Text(coinsText)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .opacity(contentOpacity)

                Image("coinImage")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(contentOpacity)
            }
        }
        .frame(maxWidth: 120.ds, maxHeight: 44.ds)
    }

    private var coinsText: String {
        switch state {
        case .locked, .zero:
            return "0"
        case .value(let amount):
            return "\(amount)"
        }
    }

    private var contentOpacity: Double {
        switch state {
        case .locked, .zero: return 0.3
        case .value:         return 1.0
        }
    }
}
