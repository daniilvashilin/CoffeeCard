import SwiftUI

struct CoinsInfoView: View {
    let state: CoinsBalanceState
    @State private var showNotifications: Bool = false
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        VStack {
            if let currentUser = sessionViewModel.user {
                CoinsInfoHeaderView(onToggleNotifications: { showNotifications.toggle() })
                Divider()
                CoinsProgressCardView(
                    level: currentUser.coinsLevel,
                    currentCoins: "\(currentUser.currentCoinsBalance)",
                    totalEarnedCoins: currentUser.totalCoinsEarned,
                    progress: currentUser.levelProgress,
                    rank: currentUser.computedRank
                )
                CoinsBalanceHistoryView(user: currentUser)
            }
        }
        .onAppear {
            if let user = sessionViewModel.user {
                Log.info("XP: \(user.totalCoinsEarned)")
                Log.info("Level: \(user.coinsLevel)")
                Log.info("Progress: \(user.levelProgress)")
                Log.info("Rank: \(user.computedRank.rawValue)")
            } else {
                Log.warning("CoinsInfoView appeared without user in session")
            }

            sessionViewModel.syncRankIfNeeded()
        }
    }
}

struct CoinsProgressBarView: View {
    var progress: Double
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4.ds)
                    .fill(.white.opacity(0.25))
                
                RoundedRectangle(cornerRadius: 4.ds)
                    .fill(.white)
                    .frame(width: geo.size.width * CGFloat(max(min(progress, 1), 0)))
            }
        }
        .frame(height: 12.ds)
        .clipShape(RoundedRectangle(cornerRadius: 4.ds))
    }
}

