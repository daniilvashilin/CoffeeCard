import Foundation
import SwiftUI

enum CatalogTypeModel: String, Codable, CaseIterable, Identifiable {
    case hotDrinks
    case coldDrinks
    case snacks
    case bakery
    case desserts
    case cakes
    case packageOfCookies
    case salads
    case sendwiches
    case soups
    case beverages
    
    var id : String {rawValue}
    
    var title: String {
        switch self {
        case .hotDrinks:
            return "Hot drinks"
        case .coldDrinks:
            return "Cold drinks"
        case .snacks:
            return "Snacks"
        case .bakery:
            return "Bakery"
        case .desserts:
            return "Desserts"
        case .cakes:
            return "Cakes"
        case .packageOfCookies:
            return "Package of cookies"
        case .salads:
            return "Salads"
        case .sendwiches:
            return "Sendwiches"
        case .soups:
            return "Soups"
        case .beverages:
            return "Beverages"
        }
        
    }
    
    var categoryImage: String {
        switch self {
        case .hotDrinks:
            return "hot"
        case .coldDrinks:
            return "cold"
        case .snacks:
            return "snack"
        case .bakery:
            return "bakery"
        case .desserts:
            return "dessert"
        case .cakes:
            return "cake"
        case .packageOfCookies:
            return "cookies"
        case .salads:
            return "salad"
        case .sendwiches:
            return "sandwich"
        case .soups:
            return "soup"
        case .beverages:
            return "beverage"
        }
    }
}
