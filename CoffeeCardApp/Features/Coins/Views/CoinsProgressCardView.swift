import SwiftUI

struct CoinsProgressCardView: View {
    var level: Int
    var currentCoins: String
    var totalEarnedCoins: Int
    var progress: Double
    var rank: LoyaltySystemRank  

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
                    HStack(spacing: 6) {
                        Image(rank.rankImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50.ds, height: 50.ds)

                        Text(rank.displayTitle)
                            .font(.appBody.bold())
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    Spacer()
                }
                HStack {
                    Text("Level \(level)")
                        .font(.title)
                        .foregroundStyle(.white)
                    Spacer()
                    HStack {
                        Text(currentCoins)
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
