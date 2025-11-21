import Foundation

final class LocalPromoStore {
    static let shared = LocalPromoStore()
    
    private init() {}
    
    private let fileName = "promos_cache.json"
    
    // MARK: - Path to app's Documents folder
    private var fileURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }
    
    // MARK: - Load promos from local JSON
    func load() -> [Promo]? {
        do {
            let data = try Data(contentsOf: fileURL)
            let promos = try JSONDecoder().decode([Promo].self, from: data)
            return promos
        } catch {
            Log.error("LocalPromoStore load error", error)
            return nil
        }
    }
    
    func save(_ promos: [Promo]) {
        do {
            let data = try JSONEncoder().encode(promos)
            try data.write(to: fileURL, options: .atomic)
            
            Log.info("Promos cached locally")
        } catch {
            Log.error("LocalPromoStore save error", error)
        }
    }
}
