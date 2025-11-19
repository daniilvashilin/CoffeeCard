import FirebaseFirestore
import Foundation

struct MenuItemModel: Identifiable, Codable {
    @DocumentID var documentId: String?
    var id: String { documentId ?? UUID().uuidString }
    var name: String
    var description: String?
    var imageURL: String?
    var rating: Double?
    var category: CatalogTypeModel
    var nutritionalInformation: NutritionModel?
}
