import Foundation   

struct HeaderViewModel {
    let coinsState: CoinsBalanceState
    let isSignedIn: Bool

    init(user: User?) {
        guard let user else {
            self.isSignedIn = false
            self.coinsState = .locked
            return
        }

        self.isSignedIn = true

        if user.currentCoinsBalance > 0 {
            self.coinsState = .value(user.currentCoinsBalance)
        } else {
            self.coinsState = .zero
        }
    }
}
