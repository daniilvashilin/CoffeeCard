import FirebaseFirestore

struct SeedMenuItem: Codable {
    let name: String
    let description: String?
    let imageURL: String?
    let rating: Double?
    let category: String
    let nutritionalInformation: NutritionModel?
}

final class SeedService {
    private let db = Firestore.firestore()

    func seedMenuIfEmpty() async throws {
        let snapshot = try await db.collection("menuItems")
            .limit(to: 1)
            .getDocuments()

        guard snapshot.isEmpty else {
            Log.info("Menu already exists, skipping seed")
            return
        }

        guard let url = Bundle.main.url(forResource: "MenuSeed", withExtension: "json") else {
            Log.error("MenuSeed.json not found")
            return
        }

        let data = try Data(contentsOf: url)
        let items = try JSONDecoder().decode([SeedMenuItem].self, from: data)

        for item in items {

            // валидация категории (если enum есть)
            guard let category = CatalogTypeModel(rawValue: item.category) else {
                Log.error("Unknown category in seed: \(item.category)")
                continue
            }

            var docData: [String: Any] = [
                "name": item.name,
                "category": category.rawValue
            ]

            if let description = item.description {
                docData["description"] = description
            }
            if let imageURL = item.imageURL {
                docData["imageURL"] = imageURL
            }
            if let rating = item.rating {
                docData["rating"] = rating
            }

            if let nutrition = item.nutritionalInformation {
                var nutritionData: [String: Any] = [:]
                if let calories = nutrition.calories { nutritionData["calories"] = calories }
                if let carbs = nutrition.carbohydrates { nutritionData["carbohydrates"] = carbs }
                if let protein = nutrition.protein { nutritionData["protein"] = protein }
                if let fat = nutrition.fat { nutritionData["fat"] = fat }

                if !nutritionData.isEmpty {
                    docData["nutritionalInformation"] = nutritionData
                }
            }

            try await db.collection("menuItems").addDocument(data: docData)
        }

        Log.info("Seed complete. Items added: \(items.count)")
    }
}
