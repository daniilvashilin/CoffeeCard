import Foundation

extension MenuItemModel {
    func price(
        tier: PriceTier,
        size: DrinkSize?,
        milk: MilkType?,
        sideMilk: MilkType? = nil,
        applySale: Bool = true
    ) -> Int {

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

        if applySale,
           let salePercent,
           (isSaleEligible ?? true),
           salePercent > 0 {

            let discount = result * salePercent / 100
            result -= discount
        }

        return result
    }

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
