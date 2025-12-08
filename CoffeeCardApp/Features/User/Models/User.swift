import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    
    // Profile
    var name: String
    var email: String
    var subsidizedUser: Bool
    var role: Role = .client
    
    // Optional extras:
    var phoneNumber: String?
    var avatarURL: String?
    var preferredLanguageCode: String?
    
    // Lifecycle
    var createdAt: Date?
    var updatedAt: Date?
    var lastSeenAt: Date?
    var lastLoginAt: Date?
    var lastLogoutAt: Date?
    
    // Coins / loyalty
    var currentCoinsBalance: Int = 0
    var lastCoinsUpdate: Date?
    var coinsHistory: [CoinsHistoryEntry] = []
    var coinsHistoryUpdatedAt: Date?
    var userCoinsProgressLevel: Int?
    
    var loyaltySystemRank: LoyaltySystemRank?
    var loyaltySystemRankUpdatedAt: Date?
    
    // Audit
    var modifications: [Modification] = []
    
    // Carts / orders (references)
    var activeCartId: String?
    var confirmedCartIds: [String] = []
    
    // Promo / referral
    var promoActivation: PromoActivationInfo?
    var referralCode: String?
    var referredByUserId: String?
    
    // Legal
    var privacyPolicyAcceptedAt: Date?
    var termsAcceptedAt: Date?
    
    // Activity / stats
    var totalOrdersCount: Int = 0
    var totalCoinsEarned: Int = 0
    var totalCoinsSpent: Int = 0
    
    // Personalization
    var favoriteItemIds: [String] = []
    var recentlyOrderedItemIds: [String] = []
    
    // Notifications / marketing
    var marketingPushAllowed: Bool?
    var marketingEmailAllowed: Bool?
    var fcmTokens: [String] = []
    
    // Account status
    var isBlocked: Bool = false
    var blockedReason: String?
    var deletedAt: Date?
}

struct PromoActivationInfo: Codable {
    var code: String
    var activatedAt: Date
    var activatedByAdminId: String?
    var expiresAt: Date?
    var source: String?
}

enum Role: String, Codable {
    case admin
    case barista
    case client
    case guest
    case testerMode
    case unknown
}

enum LoyaltySystemRank: String, Codable {
    case bronze = "BRONZE"
    case silver = "SILVER"
    case gold   = "GOLD"
    case platinum = "PLATINUM"
}

extension LoyaltySystemRank {
    
    var rankImageName: String {
        switch self {
        case .bronze:   return "badgeBronze"
        case .silver:   return "badgeSilver"
        case .gold:     return "badgeGold"
        case .platinum: return "badgePlatinum"
        }
    }

    var displayTitle: String {
        switch self {
        case .bronze:   return "Bronze"
        case .silver:   return "Silver"
        case .gold:     return "Gold"
        case .platinum: return "Platinum"
        }
    }
}

struct Modification: Codable {
    var adminId: String
    var timestamp: Date
    var type: ModificationType
    var field: String?
    var oldValue: String?
    var newValue: String?
    var reason: String?
}

enum ModificationType: String, Codable {
    case coinsChange
    case profileChange
    case subsidyChange
    case loyaltyRankChange
    case other
}

struct CoinsHistoryEntry: Codable {
    var amount: Int
    var balanceAfter: Int?
    var reason: String?
    var adminId: String?
    var updatedAt: Date
}
