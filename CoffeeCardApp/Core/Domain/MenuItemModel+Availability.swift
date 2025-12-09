import Foundation

// MARK: Helper for hiding or mark item Unavailable to order

extension MenuItemModel {
    
    func isAvailable(at date: Date = Date(), calendar: Calendar = .current) -> Bool {
        if isHidden == true || isOutOfStock == true {
            return false
        }
        
        let components = calendar.dateComponents([.weekday, .hour], from: date)
        guard let hour = components.hour else { return true }
        
        if let from = availableFromHour, hour < from { return false }
        if let to   = availableToHour,   hour >= to { return false }
        
        if let days = availableWeekdays,
           let weekday = components.weekday {
            _ = days
            _ = weekday
        }
        
        return true
    }
}
