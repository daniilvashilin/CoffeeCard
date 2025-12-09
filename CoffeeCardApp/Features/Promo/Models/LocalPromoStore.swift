import Foundation

/// Simple local disk storage for promos.
/// Saves JSON into Caches directory so system can clean it if needed.
final class LocalPromoStore {
    
    // MARK: - Singleton
    
    static let shared = LocalPromoStore()
    private init() {}
    
    
    // MARK: - Paths
    
    private let cacheFileName = "promoCache.json"
    
    private var cacheURL: URL? {
        do {
            let dir = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return dir.appendingPathComponent(cacheFileName)
        } catch {
            Log.error("[PromoCache] Failed to get caches directory", error: error)
            return nil
        }
    }
    
    
    // MARK: - Public API
    
    /// Save promos to disk as JSON.
    func save(_ promos: [Promo]) {
        guard let url = cacheURL else { return }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(promos)
            try data.write(to: url, options: .atomic)
            Log.debug("[PromoCache] Saved \(promos.count) promos")
        } catch {
            Log.error("[PromoCache] Failed to save", error: error)
        }
    }
    
    
    /// Load promos from disk if cache exists.
    func load() -> [Promo]? {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let promos = try decoder.decode([Promo].self, from: data)
            Log.debug("[PromoCache] Loaded \(promos.count) promos from disk")
            return promos
        } catch {
            Log.error("[PromoCache] Failed to load", error: error)
            return nil
        }
    }
    
    
    /// Remove cached promos file.
    func clear() {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            Log.debug("[PromoCache] Cleared promo cache")
        } catch {
            Log.error("[PromoCache] Failed to clear cache", error: error)
        }
    }
}
