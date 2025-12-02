import Foundation

protocol MenuRepository {
    func fetchMenu() async throws -> [MenuItemModel]
}
