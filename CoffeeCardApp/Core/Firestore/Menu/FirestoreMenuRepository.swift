import FirebaseFirestore
import Foundation

final class FirestoreMenuRepository: MenuRepository {
    private let db = Firestore.firestore()
    
    func fetchMenu() async throws -> [MenuItemModel] {
        Log.debug("[MenuRepository] Fetching menu from Firestore…")
        
        let snapshot = try await db.collection("menuItems").getDocuments()
        
        let items: [MenuItemModel] = snapshot.documents.compactMap { document in
            do {
                return try document.data(as: MenuItemModel.self)
            } catch {
                Log.error("[MenuRepository] Failed to decode MenuItemModel from doc \(document.documentID)", error: error)
                return nil
            }
        }
        
        Log.info("[MenuRepository] Menu fetched: \(items.count) items")
        return items
    }
}
