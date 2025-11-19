import Combine
import Foundation

final class PromoViewModel: ObservableObject {
    @Published var promos: [Promo] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: PromoRepository
    
    init(repository: PromoRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadPromos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await repository.fetchPromos()
            promos = result 
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
