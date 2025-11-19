import FirebaseFirestore
import Foundation


protocol PromoRepository {
    func fetchPromos() async throws -> [Promo]
}
