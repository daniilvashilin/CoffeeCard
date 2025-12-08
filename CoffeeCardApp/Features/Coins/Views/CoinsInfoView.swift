import SwiftUI

struct CoinsInfoView: View {
    let state: CoinsBalanceState
    var body: some View {
        VStack {
            HStack {
                Text("The amount of: \(coinsText)")
                    .foregroundStyle(.primaryText)
                Image(.coin)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
    private var coinsText: String {
        switch state {
        case .locked, .zero:
            return "0"
        case .value(let amount):
            return "\(amount)"
        }
    }
}



