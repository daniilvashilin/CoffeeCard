
enum CoinsBalanceState {
    case locked      // user not logged in
    case zero        // logged in, 0 coins
    case value(Int)  // logged in, > 0 coins
}


extension User {
    /// Сколько всего XP — по сути totalCoinsEarned, но без минусов
    var xp: Int {
        max(totalCoinsEarned, 0)
    }

    /// Сколько нужно монет на 1 уровень
    var xpPerLevel: Int {
        1000
    }

    /// Текущий уровень (1, 2, 3, ...)
    var coinsLevel: Int {
        xp / xpPerLevel + 1
    }

    /// Сколько XP набрано внутри текущего уровня
    var xpInCurrentLevel: Int {
        xp % xpPerLevel
    }

    /// Прогресс уровня [0.0 ... 1.0]
    var levelProgress: Double {
        guard xpPerLevel > 0 else { return 0 }
        return Double(xpInCurrentLevel) / Double(xpPerLevel)
    }

    /// Ранг, который **вычисляем**, а не читаем
    var computedRank: LoyaltySystemRank {
        switch xp {
        case 0..<1_000:      return .bronze
        case 1_000..<5_000:  return .silver
        case 5_000..<15_000: return .gold
        default:             return .platinum
        }
    }
}
