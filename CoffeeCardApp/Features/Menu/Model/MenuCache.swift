import Foundation

/// Simple disk cache for menu items.
/// Stores data in Library/Caches so the system can clean it if needed.
enum MenuCache {
    
    /// File name for storing cached menu.
    private static let cacheFileName = "menuItemsCache.json"
    
    /// URL to the cache file in the app's Caches directory.
    private static var cacheURL: URL? {
        do {
            let dir = try FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return dir.appendingPathComponent(cacheFileName)
        } catch {
            Log.error("[MenuCache] Failed to get caches directory", error: error)
            return nil
        }
    }
    
    
    /// Save menu items to disk as JSON.
    static func save(_ items: [MenuItemModel]) {
        guard let url = cacheURL else { return }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            try data.write(to: url, options: .atomic)
            Log.debug("[MenuCache] Saved \(items.count) items")
        } catch {
            Log.error("[MenuCache] Failed to save menu cache", error: error)
        }
    }
    
    
    /// Load menu items from disk if cache file exists.
    static func load() -> [MenuItemModel]? {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([MenuItemModel].self, from: data)
            Log.debug("[MenuCache] Loaded \(items.count) items from disk")
            return items
        } catch {
            Log.error("[MenuCache] Failed to load menu cache", error: error)
            return nil
        }
    }
    
    
    /// Remove cached menu file from disk.
    static func clear() {
        guard let url = cacheURL,
              FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            Log.debug("[MenuCache] Cleared menu cache file")
        } catch {
            Log.error("[MenuCache] Failed to clear menu cache", error: error)
        }
    }
}
