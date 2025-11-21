import FirebaseFirestore
import Foundation
import SwiftUI

struct Promo: Identifiable, Codable {
    var id: String
    var imageURL: String
    var title: String?
    var description: String?
}
