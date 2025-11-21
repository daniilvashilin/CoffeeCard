import SwiftUI
import Foundation

final class MenuViewModel: ObservableObject {
    @Published var items: [MenuItemModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var preloadedURLs = Set<URL>()
    
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
            preloadImages(for: fetched)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func items(for category: CatalogTypeModel) -> [MenuItemModel] {
        items.filter { $0.category == category }
    }
    
    private func preloadImages(for items: [MenuItemModel]) {
           Task.detached { [weak self] in
               guard let self else { return }

               let urls = items.compactMap { URL(string: $0.imageURL ?? "") }
               let session = URLSession.shared

               for url in urls {
                   if Task.isCancelled { return }
                   if self.preloadedURLs.contains(url) { continue }

                   // we don't care about result, just fill URLCache
                   _ = try? await session.data(from: url)
                   self.preloadedURLs.insert(url)
               }
           }
       }
}
