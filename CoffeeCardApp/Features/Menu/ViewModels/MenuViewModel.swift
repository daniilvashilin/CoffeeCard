import SwiftUI
import Foundation

final class MenuViewModel: ObservableObject {
    @Published var items: [MenuItemModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: MenuRepository

    init(repository: MenuRepository) {
        self.repository = repository
    }

    @MainActor
    func loadMenu() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await repository.fetchMenu()
            items = fetched
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func items(for category: CatalogTypeModel) -> [MenuItemModel] {
        items.filter { $0.category == category }
    }
}
