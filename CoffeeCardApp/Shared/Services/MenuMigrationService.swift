import FirebaseFirestore

final class MenuMigrationService {
    private let db = Firestore.firestore()
    
    func migrateMenuItems() async throws {
        let snapshot = try await db.collection("menuItems").getDocuments()
        
        let regularSideMilk: [String: Int] = [
            "regular": 0,
            "lactoseFree": 0,
            "soy": 3,
            "oat": 3,
            "almond": 3
        ]
        
        let subsidizedSideMilk: [String: Int] = [
            "regular": 0,
            "lactoseFree": 0,
            "soy": 2,
            "oat": 3,
            "almond": 3
        ]
        
        for document in snapshot.documents {
            let data = document.data()
            var update: [String: Any] = [:]
            
            // --- Pricing defaults ---
            if data["basePriceAgorot"] == nil {
                update["basePriceAgorot"] = 0
            }
            if data["largePriceAgorot"] == nil {
                update["largePriceAgorot"] = 0
            }
            
            if data["extraMilkPriceAgorot"] == nil {
                update["extraMilkPriceAgorot"] = [String: Int]()
            }
            
            update["sideMilkPriceAgorot"] = regularSideMilk
            update["subsidizedSideMilkPriceAgorot"] = subsidizedSideMilk
            
            if data["subsidizedBasePriceAgorot"] == nil {
                update["subsidizedBasePriceAgorot"] = 0
            }
            if data["subsidizedLargePriceAgorot"] == nil {
                update["subsidizedLargePriceAgorot"] = 0
            }
            if data["subsidizedExtraMilkPriceAgorot"] == nil {
                update["subsidizedExtraMilkPriceAgorot"] = [String: Int]()
            }
            
            // --- Loyalty ---
            if data["loyaltyPointsPerUnit"] == nil {
                update["loyaltyPointsPerUnit"] = 0
            }
            
            // --- Sales / flags ---
            if data["isSaleEligible"] == nil {
                update["isSaleEligible"] = true
            }
            if data["salePercent"] == nil {
                update["salePercent"] = 0
            }
            if data["isNew"] == nil { update["isNew"] = false }
            if data["isRecommended"] == nil { update["isRecommended"] = false }
            if data["isPopular"] == nil { update["isPopular"] = false }
            
            // --- Visibility ---
            if data["isHidden"] == nil { update["isHidden"] = false }
            if data["isOutOfStock"] == nil { update["isOutOfStock"] = false }
            if data["sortOrder"] == nil { update["sortOrder"] = 0 }
            
            // --- Time / days ---
            if data["availableFromHour"] == nil { update["availableFromHour"] = 0 }
            if data["availableToHour"] == nil { update["availableToHour"] = 24 }
            if data["availableWeekdays"] == nil {
                update["availableWeekdays"] = [
                    "sunday","monday","tuesday",
                    "wednesday","thursday","friday","saturday"
                ]
            }
            
            // --- Kitchen helpers ---
            if data["kitchenShortName"] == nil {
                update["kitchenShortName"] = ""
            }
            if data["preparationTimeSeconds"] == nil {
                update["preparationTimeSeconds"] = 0
            }
            
            if update.isEmpty { continue }
            Log.info("🔧 Migrating \(document.documentID) with fields: \(update.keys)")
            try await document.reference.setData(update, merge: true)
        }
        Log.info(">>> Menu items migration completed")
    }
}
