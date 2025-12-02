import Combine
import Foundation

final class PromoViewModel: ObservableObject {
    @Published var promos: [Promo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var hasLoadedOnce = false
    private let repository: PromoRepository
    
    private var preloadedURLs = Set<URL>()
    
    init(repository: PromoRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadPromos(force: Bool = false) async {
        if hasLoadedOnce && !force { return }
        
        isLoading = true
        errorMessage = nil
        
        if !force, let cached = LocalPromoStore.shared.load() {
            self.promos = cached
            preloadImages(for: cached)
        }
        
        do {
            let result = try await repository.fetchPromos()
            self.promos = result
            
            // Save to disk cache
            LocalPromoStore.shared.save(result)
            
            preloadImages(for: result)
            
            hasLoadedOnce = true
        } catch {
            if promos.isEmpty {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    
    // MARK: - Image Preloading
    private func preloadImages(for promos: [Promo]) {
        Task.detached { [weak self] in
            guard let self else { return }

            let urls = promos.compactMap { URL(string: $0.imageURL) }
            let session = URLSession.shared

            for url in urls {
                if Task.isCancelled { return }
                if self.preloadedURLs.contains(url) { continue }

                _ = try? await session.data(from: url)
                self.preloadedURLs.insert(url)
            }
        }
    }
}
