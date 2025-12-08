import SwiftUI

struct CoinsInfoView: View {
    let state: CoinsBalanceState
    @State private var showNotifications: Bool = false
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    var body: some View {
        VStack {
            if let currentUser = sessionViewModel.user {
                CoinsInfoHeaderView {showNotifications.toggle()}
                Divider()
                CoinsProgressCardView(
                    level: currentUser.coinsLevel,
                    currentCoins: "\(currentUser.currentCoinsBalance)",
                    totalEarnedCoins: currentUser.totalCoinsEarned,
                    progress: currentUser.levelProgress,
                    rank: currentUser.computedRank
                )
                
                CoinsBalanceHistoryProgressBar(user: currentUser)
            }
        }
        .onAppear {
            print("XP:", sessionViewModel.user?.totalCoinsEarned ?? 0)
            print("level:", sessionViewModel.user?.coinsLevel ?? 0)
            print("progress:", sessionViewModel.user?.levelProgress ?? 0)
            print("rank:", sessionViewModel.user?.computedRank.rawValue ?? "nil")
            sessionViewModel.syncRankIfNeeded()
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



func CoinsInfoHeaderView(onToggleNotifications: @escaping () -> Void) -> some View {
    HStack {
        Text("Rewards")
            .font(.title.bold())
            .foregroundStyle(.primaryText)
        Spacer()
        Button {
            onToggleNotifications()
        } label: {
            Image(systemName: "bell")
                .font(.title2.bold())
                .foregroundStyle(.accentApp)
        }
        
    }
    .padding()
}

struct CoinsProgressCardView: View {
    var level: Int
    var currentCoins: String
    var totalEarnedCoins: Int
    var progress: Double
    var rank: LoyaltySystemRank?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.ds)
                .fill(.accentApp)
                .frame(height: 200.ds)
            VStack {
                HStack {
                    Text("Your current level")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let rank {
                        HStack(spacing: 6) {
                            Image(rank.rankImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50.ds, height: 50.ds)
                            
                            Text(rank.displayTitle)
                                .font(.appBody.bold())
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    Spacer()
                }
                HStack {
                    Text("Level \(level)")
                        .font(.title)
                        .foregroundStyle(.white)
                    Spacer()
                    HStack {
                        Text("\(currentCoins)")
                            .font(.title2)
                            .foregroundStyle(.white)
                        Image(.coin)
                            .resizable()
                            .frame(width: 30.ds, height: 30.ds)
                    }
                }
                CoinsProgressBarView(progress: progress)
                Text("Your level progress")
                    .font(.appBody)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .frame(height: 200.ds)
        .padding()
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

struct CoinsBalanceHistoryProgressBar : View {
    var user: User
    
    private var sortedHistory: [CoinsHistoryEntry] {
        user.coinsHistory.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var body: some View {
        VStack(spacing: 8.ds) {
            HStack {
                Text("Coins History")
                    .font(.appBody)
                    .foregroundStyle(.primaryText)
                Spacer()
            }
            ScrollView {
                if !user.coinsHistory.isEmpty {
                    LazyVStack {
                        ForEach(Array(sortedHistory.enumerated()), id: \.offset) { index, entry in
                            coinsRowView(for: entry)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Yor history is empty")
                        Spacer()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }
    
    func coinsRowView(for entry: CoinsHistoryEntry) -> some View {
        let isPositive = entry.amount > 0
        let amountText = "\(isPositive ? "+" : "")\(entry.amount)"
        
        return HStack(alignment: .center, spacing: 12) {
            
            Circle()
                .fill(isPositive ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(entry.reason ?? "Transaction")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(entry.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(amountText)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isPositive ? .green : .red)
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}


