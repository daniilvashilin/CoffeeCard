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
    
    /// Универсальный метод загрузки:
    /// 1) загружает кеш
    /// 2) обновляет с сервера
    /// 3) прелоад изображений
    @MainActor
    func loadPromos(force: Bool = false) async {
        // Если уже загружали и не нужно принудительно — выходим
        if hasLoadedOnce && !force { return }
        
        isLoading = true
        errorMessage = nil
        
        // --- 1. Сначала пробуем локальный кеш ---
        if !force, let cached = LocalPromoStore.shared.load() {
            self.promos = cached
        }
        
        // --- 2. Загружаем свежие данные с Firestore ---
        do {
            let result = try await repository.fetchPromos()
            self.promos = result
            
            // Сохраняем в кеш
            LocalPromoStore.shared.save(result)
            
            // Прелоад картинок
            preloadImages(for: result)
            
            hasLoadedOnce = true
        } catch {
            // Показываем ошибку только если вообще нет данных
            if promos.isEmpty {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }
    
    // MARK: - Preload
    
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
