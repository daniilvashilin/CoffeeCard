import FirebaseFirestore
import Foundation

struct SeedMenuItem: Codable {
    let name: String
    let description: String?
    let imageURL: String?
    let rating: Double?
    let category: String
    let nutritionalInformation: NutritionModel?
    let weight: Double?
    let milkOptions: [MilkType]?
    let dietaryTags: [DietaryTag]?
}

final class SeedService {
    private let db = Firestore.firestore()
    private let collectionName = "menuItems"

    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func seedMenuFromJSONUpsert(jsonFile: String = "MenuSeed",
                                ext: String = "json") async throws {

        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: ext) else {
            print("❌ \(jsonFile).json not found in bundle")
            return
        }

        let data = try Data(contentsOf: url)
        let items = try JSONDecoder().decode([SeedMenuItem].self, from: data)

        if items.isEmpty {
            print("ℹ️ Seed file empty")
            return
        }

        let snapshot = try await db.collection(collectionName).getDocuments()

        // Собираем map: normalizedName -> DocumentSnapshot
        var existingByName: [String: QueryDocumentSnapshot] = [:]
        for doc in snapshot.documents {
            if let name = doc.data()["name"] as? String {
                existingByName[normalize(name)] = doc
            }
        }

        print("🌱 Upserting \(items.count) items...")

        let chunkSize = 400
        var start = 0

        while start < items.count {
            let end = min(start + chunkSize, items.count)
            let chunk = items[start..<end]
            let batch = db.batch()

            for item in chunk {
                let key = normalize(item.name)

                let payload: [String: Any] = [
                    "name": item.name,
                    "description": item.description as Any,
                    "imageURL": item.imageURL as Any,
                    "rating": item.rating as Any,
                    "category": item.category,
                    "weight": item.weight as Any,
                    "milkOptions": item.milkOptions?.map { $0.rawValue } as Any,
                    "dietaryTags": item.dietaryTags?.map { $0.rawValue } as Any,
                    "nutritionalInformation": item.nutritionalInformation.map {
                        [
                            "calories": $0.calories as Any,
                            "carbohydrates": $0.carbohydrates as Any,
                            "protein": $0.protein as Any,
                            "fat": $0.fat as Any
                        ]
                    } as Any
                ]

                if let existingDoc = existingByName[key] {
                    // update existing
                    batch.setData(payload, forDocument: existingDoc.reference, merge: true)
                    print("🔁 update:", item.name)
                } else {
                    // add new
                    let ref = db.collection(collectionName).document()
                    batch.setData(payload, forDocument: ref)
                    print("➕ add:", item.name)
                }
            }

            try await batch.commit()
            start = end
        }

        print("✅ Seed complete (upsert)")
    }
}
