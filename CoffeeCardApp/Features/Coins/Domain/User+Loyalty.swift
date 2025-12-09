extension User {
    
    var xp: Int {
        max(totalCoinsEarned, 0)
    }

    var xpPerLevel: Int {
        1000
    }

    var coinsLevel: Int {
        xp / xpPerLevel + 1
    }

    var xpInCurrentLevel: Int {
        xp % xpPerLevel
    }

    var levelProgress: Double {
        guard xpPerLevel > 0 else { return 0 }
        return Double(xpInCurrentLevel) / Double(xpPerLevel)
    }


    var computedRank: LoyaltySystemRank {
        switch xp {
        case 0..<1_000:      return .bronze
        case 1_000..<5_000:  return .silver
        case 5_000..<15_000: return .gold
        default:             return .platinum
        }
    }
}
