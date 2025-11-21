import FirebaseFirestore
import Foundation

final class FirestoreMenuRepository: MenuRepository {
    private let db = Firestore.firestore()
    
    func fetchMenu() async throws -> [MenuItemModel] {
        let snapshot = try await db.collection("menuItems").getDocuments()
        
        let items: [MenuItemModel] = snapshot.documents.compactMap { document in
            do {
                return try document.data(as: MenuItemModel.self)
            } catch {
                Log.error("Failed to decode MenuItemModel from doc \(document.documentID): \(error)")
                return nil
            }
        }
        
        return items
    }
}
