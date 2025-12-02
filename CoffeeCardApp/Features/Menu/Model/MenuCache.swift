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
            Log.error("Failed to get caches directory for menu cache", error)
            return nil
        }
    }
    
    /// Save menu items to disk as JSON.
    static func save(_ items: [MenuItemModel]) {
        guard let url = cacheURL else { return }
        
        do {
            let encoder = JSONEncoder()
            // You can add dateEncodingStrategy if you later add dates to MenuItemModel.
            let data = try encoder.encode(items)
            try data.write(to: url, options: .atomic)
            Log.info("Menu cache saved: \(items.count) items")
        } catch {
            Log.error("Failed to save menu cache", error)
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
            Log.info("Menu cache loaded: \(items.count) items")
            return items
        } catch {
            Log.error("Failed to load menu cache", error)
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
            Log.info("Menu cache cleared")
        } catch {
            Log.error("Failed to clear menu cache", error)
        }
    }
}
