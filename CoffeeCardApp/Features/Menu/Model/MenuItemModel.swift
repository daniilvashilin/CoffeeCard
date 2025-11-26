import FirebaseFirestore
import SwiftUICore
import Foundation

struct MenuItemModel: Identifiable, Codable {
    @DocumentID var documentId: String?
    var id: String { documentId ?? UUID().uuidString }
    
    var name: String
    var description: String?
    var imageURL: String?
    var rating: Double?
    var category: CatalogTypeModel
    var nutritionalInformation: NutritionModel?
    var weight: Double?
    
    var milkOptions: [MilkType]?
    var dietaryTags: [DietaryTag]?
    var DrinkSizeOptions: [DrinkSize]?
}


enum DrinkSize: String, Codable, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case small
    case large
    
    var title: String {
        switch self {
        case .small: return "S"
        case .large: return "L"
        }
    }
    
    var sizeImageName: String {
        switch self {
        case .small: return "small"
        case .large: return "large"
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
            case .regular: return .regilarMilk
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
