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
        let snapshot = try await db.collection("menuItems").limit(to: 1).getDocuments()

        guard snapshot.isEmpty else {
            print("⚠️ Menu already exists, skipping seed.")
            return
        }

        guard let url = Bundle.main.url(forResource: "MenuSeed", withExtension: "json") else {
            print("❌ MenuSeed.json not found")
            return
        }

        let data = try Data(contentsOf: url)
        let items = try JSONDecoder().decode([SeedMenuItem].self, from: data)

        for item in items {
            var data: [String: Any] = [
                "name": item.name,
                "description": item.description as Any,
                "imageURL": item.imageURL as Any,
                "rating": item.rating as Any,
                "category": item.category,  // enum rawValue string
            ]

            if let nutrition = item.nutritionalInformation {
                data["nutritionalInformation"] = [
                    "calories": nutrition.calories as Any,
                    "carbohydrates": nutrition.carbohydrates as Any,
                    "protein": nutrition.protein as Any,
                    "fat": nutrition.fat as Any
                ]
            }

            try await db.collection("menuItems").addDocument(data: data)
        }

        print("✅ Seed complete. Items added: \(items.count)")
    }
}
