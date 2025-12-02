import UIKit

/// Simple in-memory image cache for menu images.
/// Uses NSCache so the system can automatically clear it under memory pressure.
final class MenuImageCache {
    static let shared = MenuImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        let cost = image.pngData()?.count ?? 0
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
    
    func remove(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
