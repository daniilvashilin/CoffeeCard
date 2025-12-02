import FirebaseFirestore
import SwiftUI

struct MenuItemModel: Identifiable, Codable {
    @DocumentID var documentId: String?
    
    /// Temporary local identifier used before Firestore assigns `documentId`.
    /// Will never be encoded into Firestore.
    var localId: String = UUID().uuidString
    
    /// Public identifier — Firestore ID if available, otherwise a temporary local ID.
    var id: String { documentId ?? localId }
    
    
    // MARK: - Basic information
    
    /// Main display name (fallback if localization is not provided).
    var name: String
    
    /// Main description (fallback if localization is not provided).
    var description: String?
    
    /// URL string for the product image stored in Firestore Storage.
    var imageURL: String?
    
    /// User rating (optional, may be added later).
    var rating: Double?
    
    /// Category under which this item appears in the menu.
    var category: CatalogTypeModel
    
    /// Optional nutritional information (calories, fats, etc.).
    var nutritionalInformation: NutritionModel?
    
    /// Weight in grams (if relevant).
    var weight: Double?
    
    
    // MARK: - Localization
    
    /// Localized name for different languages (he / en / ru).
    var localizedName: LocalizedText?
    
    /// Localized description for different languages (he / en / ru).
    var localizedDescription: LocalizedText?
    
    
    // MARK: - Configurable options displayed in the UI
    
    /// Available milk types for this drink.
    /// If `nil` → this item does not support milk selection.
    var milkOptions: [MilkType]?
    
    /// Dietary tags such as dairy, parve, vegan, gluten-free.
    var dietaryTags: [DietaryTag]?
    
    /// Available serving sizes (Small / Large).
    /// If `nil` or contains only one element → the size selector can be hidden.
    var drinkSizeOptions: [DrinkSize]?
    
    /// Caffeine variants (regular / decaf).
    /// If `nil` → assume `.regular` only.
    var availableCaffeineOptions: [CaffeineOption]?
    
    
    // MARK: - Pricing (standard & subsidized)
    
    /// Base price in agorot (Small or the only available size) for regular customers.
    var basePriceAgorot: Int
    
    /// Price for Large size (in agorot) for regular customers.
    /// If `nil` → fallback to `basePriceAgorot`.
    var largePriceAgorot: Int?
    
    /// Extra charge when replacing regular milk (for regular customers).
    /// Dictionary: MilkType → extra cost in agorot.
    var extraMilkPriceAgorot: [String: Int]?
    
    /// Price for “milk on the side” (for regular customers).
    /// Dictionary: MilkType → cost in agorot.
    var sideMilkPriceAgorot: [String: Int]?
    
    /// Base price in agorot for subsidized accounts (staff).
    /// If `nil` → use `basePriceAgorot`.
    var subsidizedBasePriceAgorot: Int?
    
    /// Large size price in agorot for subsidized accounts.
    /// If `nil` → use `subsidizedBasePriceAgorot` or regular large price.
    var subsidizedLargePriceAgorot: Int?
    
    /// Extra charge for milk replacement for subsidized accounts.
    /// If `nil` → fallback to `extraMilkPriceAgorot`.
    var subsidizedExtraMilkPriceAgorot: [String: Int]?
    
    /// Price for “milk on the side” for subsidized accounts.
    /// If `nil` → fallback to `sideMilkPriceAgorot`.
    var subsidizedSideMilkPriceAgorot: [String: Int]?
    
    
    // MARK: - Loyalty
    
    /// How many bonus points (coins) user earns for 1 unit of this item.
    /// If `nil` or 0 → no loyalty points are granted.
    var loyaltyPointsPerUnit: Int?
    
    
    // MARK: - Sales & marketing flags
    
    /// Indicates whether this item can participate in timed discounts (night sales, clearance, etc.).
    /// If `nil` → treat as `true`.
    var isSaleEligible: Bool?
    
    /// Optional active sale percentage (e.g., 30 = 30% off).
    /// If `nil` → no sale applied.
    var salePercent: Int?
    
    /// Mark item as "new" in the menu.
    var isNew: Bool?
    
    /// Mark item as "recommended" (for carousels, badges, etc.).
    var isRecommended: Bool?
    
    /// Mark item as "popular" (based on sales or manual decision).
    var isPopular: Bool?
    
    
    // MARK: - Visibility & availability
    
    /// If `true` → item is hidden from the menu (soft-delete / temporarily disabled).
    var isHidden: Bool?
    
    /// If `true` → item is temporarily unavailable / out of stock.
    /// You can show it as disabled or greyed-out in the UI.
    var isOutOfStock: Bool?
    
    /// Optional sort order inside a category (lower comes first).
    var sortOrder: Int?
    
    
    // MARK: - Time & day-based availability
    
    /// Hour of the day (0...23) when this item starts being available.
    /// If `nil` → no lower time limit.
    var availableFromHour: Int?
    
    /// Hour of the day (0...23) when this item stops being available.
    /// If `nil` → no upper time limit.
    var availableToHour: Int?
    
    /// Days of the week when this item is available.
    /// If `nil` or empty → treat as available every day.
    var availableWeekdays: [Weekday]?
    
    
    // MARK: - Bar / kitchen helpers
    
    /// Short name used on kitchen / bar screens or tickets (more compact than `name`).
    var kitchenShortName: String?
    
    /// Estimated preparation time in seconds (for customer-facing ETA or for bar).
    var preparationTimeSeconds: Int?
    
    
    // MARK: - CodingKeys (localId intentionally excluded)
    
    enum CodingKeys: String, CodingKey {
//        case documentId
        case name
        case description
        case imageURL
        case rating
        case category
        case nutritionalInformation
        case weight
        
        case localizedName
        case localizedDescription
        
        case milkOptions
        case dietaryTags
        case drinkSizeOptions
        case availableCaffeineOptions
        
        case basePriceAgorot
        case largePriceAgorot
        case extraMilkPriceAgorot
        case sideMilkPriceAgorot
        case subsidizedBasePriceAgorot
        case subsidizedLargePriceAgorot
        case subsidizedExtraMilkPriceAgorot
        case subsidizedSideMilkPriceAgorot
        
        case loyaltyPointsPerUnit
        
        case isSaleEligible
        case salePercent
        case isNew
        case isRecommended
        case isPopular
        
        case isHidden
        case isOutOfStock
        case sortOrder
        
        case availableFromHour
        case availableToHour
        case availableWeekdays
        
        case kitchenShortName
        case preparationTimeSeconds
    }
}

struct LocalizedText: Codable {
    var he: String?
    var en: String?
    var ru: String?
}

enum Weekday: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

enum CaffeineOption: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case regular
    case decaf
    
    var title: String {
        switch self {
        case .regular: return "With caffeine"
        case .decaf:   return "Decaf"
        }
    }
}

enum DrinkSize: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case small
    case large
    case none
    
    var title: String {
        switch self {
        case .small: return "S"
        case .large: return "L"
        case .none: return "N"
        }
    }
    
    var secondTitle: String {
        switch self {
        case .small: return "Small"
        case .large: return "Large"
        case .none: return "None"
        }
    }
    
    var sizeImageName: String {
        switch self {
        case .small: return "small"
        case .large: return "large"
        case .none: return "none"
        }
    }
}

enum MilkType: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case regular
    case lactoseFree
    case soy
    case almond
    case oat
    
    var title: String {
        switch self {
        case .regular: return "Regular Milk"
        case .lactoseFree: return "Lacto-Free"
        case .soy: return "Soy Milk"
        case .almond: return "Almond Milk"
        case .oat: return "Oat Milk"
        }
    }
    
    var imageName: String {
        switch self {
        case .regular: return "milk"
        case .lactoseFree: return "lactoseFree"
        case .soy: return "soyMilk"
        case .almond: return "almond"
        case .oat: return "oatMilk"
        }
    }
    
    var milkTypeColor: Color {
        switch self {
        case .regular: return .regularMilk
        case .lactoseFree: return .lactoseFree
        case .soy: return .soyMilk
        case .almond: return .almondMilk
        case .oat: return .oatMilk
        }
    }
}

enum DietaryTag: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case dairy
    case parve
    case vegan
    case glutenFree
    
    var title: String {
        switch self {
        case .dairy: return "Dairy"
        case .parve: return "Parve"
        case .vegan: return "Vegan"
        case .glutenFree: return "Gluten Free"
        }
    }
    
    var imageName: String {
        switch self {
        case .dairy: return "halavi"
        case .parve: return "parve"
        case .vegan: return "vegan"
        case .glutenFree: return "glutenFree"
        }
    }
}

enum PriceTier {
    case regular
    case subsidized
}
