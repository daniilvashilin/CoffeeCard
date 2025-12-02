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

    // MARK: - Public API
    
    /// Load menu with optional cached data shown first (if available).
    @MainActor
    func loadMenu() async {
        // 1. Try to show cached items immediately (if items are currently empty)
        if items.isEmpty, let cached = MenuCache.load(), !cached.isEmpty {
            Log.info("Using cached menu items as initial data")
            self.items = cached
        }
        
        // 2. Fetch fresh data from Firestore
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await repository.fetchMenu()
            Log.info("Loaded \(fetched.count) menu items from repository")
            
            // Update in-memory items
            self.items = fetched
            
            // Save new cache to disk
            MenuCache.save(fetched)
            
            // Preload images in background
            preloadImages(for: fetched)
        } catch {
            Log.error("Failed to load menu from repository", error)
            // Keep cached data (if any) and show error message
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    /// Force reload menu, ignoring existing cache.
    @MainActor
    func reloadMenu() async {
        Log.info("Force reload menu: clearing cache and re-fetching from repository")
        MenuCache.clear()
        self.items.removeAll()
        self.preloadedURLs.removeAll()
        await loadMenu()
    }

    /// Helper to filter items by category for UI.
    func items(for category: CatalogTypeModel) -> [MenuItemModel] {
        items.filter { $0.category == category }
    }
    
    // MARK: - Image preloading
    
    /// Preload images into URLCache so that AsyncImage can show them faster later.
    private func preloadImages(for items: [MenuItemModel]) {
        Task.detached { [weak self] in
            guard let self else { return }

            let urls = items.compactMap { URL(string: $0.imageURL ?? "") }
            let session = URLSession.shared

            for url in urls {
                if Task.isCancelled { return }
                if self.preloadedURLs.contains(url) { continue }

                _ = try? await session.data(from: url)
                self.preloadedURLs.insert(url)
            }
            
            Log.info("Preloaded \(self.preloadedURLs.count) image URLs")
        }
    }
}
