import Foundation

// MARK: - Int + Currency

extension NumberFormatter {
    static let shekelFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "ILS"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        return f
    }()
}

// MARK: Helper for making item availvel at some Time range
extension MenuItemModel {
    func isAvailable(at date: Date = Date(), calendar: Calendar = .current) -> Bool {
        // hidden / out of stock
        if isHidden == true || isOutOfStock == true {
            return false
        }
        
        let components = calendar.dateComponents([.weekday, .hour], from: date)
        guard let hour = components.hour else { return true }
        
        // time window
        if let from = availableFromHour, hour < from { return false }
        if let to   = availableToHour,   hour >= to { return false }
        
        // weekdays
        if let days = availableWeekdays,
           let weekday = components.weekday {
        }
        
        return true
    }
}

extension Int {
    func asShekelString() -> String {
        let value = Double(self) / 100.0
        return NumberFormatter.shekelFormatter.string(from: NSNumber(value: value)) ?? "₪\(value)"
    }
}

// MARK: Helper for hiding or mark item Unavailable to order
extension MenuItemModel {
    var isVisibleInMenu: Bool {
        !(isHidden ?? false)
    }
    
    var isAvailableToOrder: Bool {
        !(isOutOfStock ?? false) && isVisibleInMenu
    }
}

// MARK: Localaized Helper
extension LocalizedText {
    func text(for locale: Locale) -> String? {
        let code = locale.language.languageCode?.identifier ?? "en"
        switch code {
        case "he": return he ?? en ?? ru
        case "ru": return ru ?? en ?? he
        default:   return en ?? he ?? ru
        }
    }
}


// MARK: - MenuItemModel + Pricing

extension MenuItemModel {
    func price(
        tier: PriceTier,
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil,
        applySale: Bool = true
    ) -> Int {

        // MARK: 1. Base + size

        let regularBase  = basePriceAgorot
        let regularLarge = largePriceAgorot ?? regularBase

        let subsidizedBase  = subsidizedBasePriceAgorot ?? regularBase
        let subsidizedLarge = subsidizedLargePriceAgorot
            ?? subsidizedBasePriceAgorot
            ?? largePriceAgorot
            ?? regularBase

        let base: Int
        let large: Int

        switch tier {
        case .regular:
            base  = regularBase
            large = regularLarge
        case .subsidized:
            base  = subsidizedBase
            large = subsidizedLarge
        }

        var result = (size == .large ? large : base)

        // MARK: 2. Milk in cup

        if let milk, milk != .regular {
            let extra: Int?

            switch tier {
            case .regular:
                extra = extraMilkPriceAgorot?[milk.rawValue]
            case .subsidized:
                extra = subsidizedExtraMilkPriceAgorot?[milk.rawValue]
                    ?? extraMilkPriceAgorot?[milk.rawValue]
            }

            if let extra {
                result += extra
            }
        }

        // MARK: 3. Milk on the side

        if let sideMilk {
            let extra: Int?

            switch tier {
            case .regular:
                extra = sideMilkPriceAgorot?[sideMilk.rawValue]
            case .subsidized:
                extra = subsidizedSideMilkPriceAgorot?[sideMilk.rawValue]
                    ?? sideMilkPriceAgorot?[sideMilk.rawValue]
            }

            if let extra {
                result += extra
            }
        }

        // MARK: 4. Sale (optional)

        if applySale,
           let salePercent,
           (isSaleEligible ?? true),
           salePercent > 0 {

            let discount = result * salePercent / 100
            result -= discount
        }

        return result
    }

    // Удобные шорткаты

    func regularPrice(
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil,
        applySale: Bool = true
    ) -> Int {
        price(tier: .regular, size: size, milk: milk, sideMilk: sideMilk, applySale: applySale)
    }

    func subsidizedPrice(
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil,
        applySale: Bool = true
    ) -> Int {
        price(tier: .subsidized, size: size, milk: milk, sideMilk: sideMilk, applySale: applySale)
    }
}

extension MenuItemModel {
    func priceForRegular(
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil
    ) -> Int {
        price(tier: .regular, size: size, milk: milk, sideMilk: sideMilk)
    }
    
    func priceForSubsidized(
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil
    ) -> Int {
        price(tier: .subsidized, size: size, milk: milk, sideMilk: sideMilk)
    }
}


// MARK: - MenuItemModel + Kosher

extension MenuItemModel {
    func kosherTag(for milk: MilkType?) -> DietaryTag? {
        guard let tags = dietaryTags else { return nil }
        
        let kosherTags = tags.filter { $0 == .dairy || $0 == .parve }
        guard !kosherTags.isEmpty else { return nil }
        
        if kosherTags.contains(.dairy) && kosherTags.contains(.parve) {
            guard let milk else { return .dairy }
            
            switch milk {
            case .regular, .lactoseFree:
                return .dairy
            case .soy, .almond, .oat:
                return .parve
            }
        }
        
        if kosherTags.contains(.dairy) { return .dairy }
        if kosherTags.contains(.parve) { return .parve }
        
        return nil
    }
}
