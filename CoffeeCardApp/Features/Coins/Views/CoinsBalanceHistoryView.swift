import SwiftUI

struct CoinsBalanceHistoryView: View {
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
                        ForEach(Array(sortedHistory.enumerated()), id: \.offset) { _, entry in
                            coinsRowView(for: entry)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Your history is empty")
                        Spacer()
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding()
    }

    private func coinsRowView(for entry: CoinsHistoryEntry) -> some View {
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
