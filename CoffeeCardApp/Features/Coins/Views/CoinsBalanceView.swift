import SwiftUI

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
                    .foregroundStyle(.primaryText)
                    .font(.headline)
                    .opacity(contentOpacity)
                
                Image("coinImage")
                    .resizable()
                    .frame(width: 28.ds, height: 28.ds)
                    .opacity(contentOpacity)
            }
        }
        .frame(maxWidth: 100.ds, maxHeight: 44.ds)
        .padding(padding)
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
        case .locked:return 0.3
        case .zero: return 1.0
        case .value:return 1.0
        }
    }
    
    private var padding: CGFloat {
        switch state {
        case .locked:return 8.ds
        case .zero, .value:return 0
        }
    }
}
