import FirebaseFirestore

extension SessionViewModel {
    func syncRankIfNeeded() {
        guard var currentUser = user,
              let userId = currentUser.id else {
            return
        }

        let newRank = currentUser.computedRank

        if currentUser.loyaltySystemRank == newRank {
            Log.debug("[RankSync] Rank already up-to-date: \(newRank.rawValue)")
            return
        }

        let db = Firestore.firestore()
        let now = Timestamp(date: Date())

        db.collection("users")
            .document(userId)
            .setData([
                "loyaltySystemRank": newRank.rawValue,
                "loyaltySystemRankUpdatedAt": now
            ], merge: true) { [weak self] error in

                if let error = error {
                    Log.error("[RankSync] Failed to update rank", error: error)
                    return
                }

                Log.debug("[RankSync] Rank updated to \(newRank.rawValue)")

                Task { @MainActor in
                    currentUser.loyaltySystemRank = newRank
                    currentUser.loyaltySystemRankUpdatedAt = Date()
                    self?.user = currentUser
                }
            }
    }
}
