import FirebaseFirestore
import Foundation

final class MigrationService {
    private let db = Firestore.firestore()

    /// Запускаем один раз, чтобы проставить dietaryTags и milkOptions
    func migrateMenuItems() async throws {
        let snapshot = try await db.collection("menuItems").getDocuments()

        // 1. Задаём наборы имен — можно подправить под твое меню
        let dairyDrinks: Set<String> = [
            "Cappuccino",
            "Hot Chocolate",
            "Nes Coffee with Milk",
            "Iced Coffee",      // если там молоко
            "Ice Coffee"        // если есть такой нейм
        ]

        let parveDrinks: Set<String> = [
            "Espresso",
            "Double Espresso",
            "Americano",
            "Black Coffee (Turkish)",
            "Tea Nana",
            "Lemonade",
            "Limonana Frozen",
            "Orange Juice",
            "Cold Coffee"       // если без молока
        ]

        // Какие напитки вообще могут иметь выбор молока:
        let drinksWithMilkOptions: Set<String> = [
            "Cappuccino",
            "Nes Coffee with Milk",
            "Hot Chocolate",
            "Ice Coffee",
            "Iced Coffee"
        ]

        for doc in snapshot.documents {
            let name  = doc["name"] as? String ?? ""
            let category = doc["category"] as? String ?? ""

            var dietary: [DietaryTag] = []
            var milk: [MilkType] = []

            // --- dietaryTags ---
            if dairyDrinks.contains(name) {
                dietary.append(.dairy)
            } else if parveDrinks.contains(name) {
                dietary.append(.parve)
            }

            // Пример: соки и салаты могут быть веган по умолчанию
            if category == "coldDrinks" && (name.contains("Juice") || name.contains("Lemon")) {
                dietary.append(.vegan)
            }

            // --- milkOptions ---
            if drinksWithMilkOptions.contains(name) {
                milk = [.regular, .lactoseFree, .soy, .almond, .oat]
            }

            var updates: [String: Any] = [:]

            if !dietary.isEmpty {
                updates["dietaryTags"] = dietary.map { $0.rawValue }
            }

            if !milk.isEmpty {
                updates["milkOptions"] = milk.map { $0.rawValue }
            }

            // Если нечего обновлять — просто пропускаем
            if updates.isEmpty { continue }

            try await doc.reference.updateData(updates)
        }
    }
}
