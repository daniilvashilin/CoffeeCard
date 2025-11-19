import Foundation
import SwiftUI

enum CustomTabModel: String, CaseIterable, Identifiable {
    case home, Menu, profile
    var id: Self { self }
    
    var titile: String {
        switch self {
        case .home:
            return "Home"
        case .Menu:
            return "Menu"
        case .profile:
            return "Profile"
        }
    }
    
    var tabIcon: String {
        switch self {
        case .home:
            return "house"
        case .Menu:
            return "square.grid.2x2"
        case .profile:
            return "person.crop.square"
        }
    }
    
    var filledIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .Menu:
            return "square.grid.2x2.fill"
        case .profile:
            return "person.crop.square.fill"
        }
    }
}
