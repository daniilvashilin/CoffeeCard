import Foundation

/// Simple local disk storage for promos.
/// Saves JSON file into Caches directory so the system can clean it if needed.
final class LocalPromoStore {
    
    // MARK: - Singleton
    
    /// Shared instance used across the app.
    static let shared = LocalPromoStore()
    
    /// Private init so no other instances are created.
    private init() {}
    
    
    // MARK: - Paths
    
    /// File name for storing cached promos.
    private let cacheFileName = "promoCache.json"
    
    /// URL to the cache file in the app's Caches directory.
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
            Log.error("Failed to get caches directory for promo cache", error)
            return nil
        }
    }
    
    
    // MARK: - Public API
    
    /// Save promos to disk as JSON.
    func save(_ promos: [Promo]) {
        guard let url = cacheURL else { return }
        
        do {
            let encoder = JSONEncoder()
            // If Promo ever has Date fields, you can set dateEncodingStrategy here.
            let data = try encoder.encode(promos)
            try data.write(to: url, options: .atomic)
            Log.info("Promos cached locally: \(promos.count) items")
        } catch {
            Log.error("Failed to save promo cache", error)
        }
    }
    
    /// Load promos from disk if cache file exists.
    func load() -> [Promo]? {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let promos = try decoder.decode([Promo].self, from: data)
            Log.info("Loaded promos from cache: \(promos.count) items")
            return promos
        } catch {
            Log.error("Failed to load promo cache", error)
            return nil
        }
    }
    
    /// Remove cached promos file from disk.
    func clear() {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            Log.info("Promo cache cleared")
        } catch {
            Log.error("Failed to clear promo cache", error)
        }
    }
}
