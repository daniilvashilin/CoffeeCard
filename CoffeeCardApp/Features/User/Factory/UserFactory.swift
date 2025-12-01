import FirebaseAuth

extension User {
    static func newFromAuth(
        authUser: FirebaseAuth.User,
        name: String? = nil
    ) -> User {
        User(
            id: authUser.uid,
            name: name ?? authUser.displayName ?? "Guest",
            email: authUser.email ?? "",
            subsidizedUser: false,
            role: .client,
            
            // optional profile
            phoneNumber: authUser.phoneNumber,
            avatarURL: authUser.photoURL?.absoluteString,
            preferredLanguageCode: nil,
            
            // lifecycle
            createdAt: Date(),
            updatedAt: Date(),
            lastSeenAt: Date(),
            lastLoginAt: Date(),
            lastLogoutAt: nil,
            
            // coins / loyalty
            currentCoinsBalance: 0,
            lastCoinsUpdate: nil,
            coinsHistory: [],
            coinsHistoryUpdatedAt: nil,
            loyaltySystemRank: nil,
            loyaltySystemRankUpdatedAt: nil,
            
            // audit
            modifications: [],
            
            // carts / orders
            activeCartId: nil,
            confirmedCartIds: [],
            
            // promo / referral
            promoActivation: nil,
            referralCode: nil,
            referredByUserId: nil,
            
            // legal
            privacyPolicyAcceptedAt: nil,
            termsAcceptedAt: nil,
            
            // stats
            totalOrdersCount: 0,
            totalCoinsEarned: 0,
            totalCoinsSpent: 0,
            
            // personalization
            favoriteItemIds: [],
            recentlyOrderedItemIds: [],
            
            // marketing
            marketingPushAllowed: nil,
            marketingEmailAllowed: nil,
            fcmTokens: [],
            
            // status
            isBlocked: false,
            blockedReason: nil,
            deletedAt: nil
        )
    }
}
