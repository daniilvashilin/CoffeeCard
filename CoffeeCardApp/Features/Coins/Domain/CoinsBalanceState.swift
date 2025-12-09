
enum CoinsBalanceState {
    case locked      // user not logged in
    case zero        // logged in, 0 coins
    case value(Int)  // logged in, > 0 coins
}



