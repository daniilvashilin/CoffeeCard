import Foundation

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
