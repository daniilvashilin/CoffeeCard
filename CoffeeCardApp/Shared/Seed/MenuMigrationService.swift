import FirebaseFirestore

final class MenuMigrationService {
    private let db = Firestore.firestore()

    func addDietaryAndMilkDefaults() async throws {
        let snapshot = try await db.collection("menuItems").getDocuments()
        let batch = db.batch()

        for doc in snapshot.documents {
            var update: [String: Any] = [:]

            let name = (doc.data()["name"] as? String) ?? ""
            let category = (doc.data()["category"] as? String) ?? ""

            // если уже есть поля – пропускаем
            let hasMilk = doc.data()["milkOptions"] != nil
            let hasTags = doc.data()["dietaryTags"] != nil

            // Пример логики — подстрой под себя
            if !hasMilk {
                if category == "hotDrinks" || category == "coldDrinks" {
                    update["milkOptions"] = [
                        "regular",
                        "lactoseFree",
                        "soy",
                        "almond",
                        "oat"
                    ]
                }
            }

            if !hasTags {
                if category == "hotDrinks" || category == "coldDrinks" {
                    update["dietaryTags"] = ["dairy"]
                } else if category == "desserts" {
                    update["dietaryTags"] = ["dairy"]
                } else if name.contains("Lemonade") || name.contains("Tea") {
                    update["dietaryTags"] = ["parve", "vegan", "glutenFree"]
                }
            }

            if !update.isEmpty {
                batch.updateData(update, forDocument: doc.reference)
            }
        }

        try await batch.commit()
        print("✅ Migration finished")
    }
}
