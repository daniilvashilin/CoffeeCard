import FirebaseFirestore
import Foundation


final class FirestorePromoRepository: PromoRepository {
    private let db = Firestore.firestore()
    
    func fetchPromos() async throws -> [Promo] {
        let snapshot = try await db.collection("promos").getDocuments()
        
        let promos: [Promo] = snapshot.documents.compactMap { doc in
            let data = doc.data()
            
            guard let imageURL = data["imageURL"] as? String else {
                return nil
            }
            
            return Promo(id: doc.documentID, imageURL: imageURL)
        }
        return promos
    }
}
