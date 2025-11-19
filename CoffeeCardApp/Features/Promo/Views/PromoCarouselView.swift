import SwiftUI

struct PromoCarouselView: View {
    // View owns the ViewModel
    @StateObject private var viewModel: PromoViewModel
    @State private var selection: Int = 0   // current page index
    
    // Custom init so we can inject the repository (DI)
    init() {
        let repo = FirestorePromoRepository()
        _viewModel = StateObject(wrappedValue: PromoViewModel(repository: repo))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Loading state
            if viewModel.isLoading {
                ProgressView("Loading promos…")
                    .frame(height: 250)
                    .padding(.horizontal, 16)
            }
            
            // Error state
            else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            // Empty state
            else if viewModel.promos.isEmpty {
                Text("No promos yet")
                    .foregroundColor(.secondary)
            }
            
            // Success state – show carousel
            else {
                carousel
            }
        }
        .padding(.vertical, 24)
        .task {
            // called once when the view appears
            await viewModel.loadPromos()
        }
    }
    
    // MARK: - Carousel view
    
    private var carousel: some View {
        VStack(spacing: 12) {
            TabView(selection: $selection) {
                ForEach(Array(viewModel.promos.enumerated()), id: \.element.id) { index, promo in
                    AsyncImage(url: URL(string: promo.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 230)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16)
                            // scale for selected page
                            .scaleEffect(selection == index ? 0.9 : 1.0)
                            .shadow(radius: selection == index ? 8 : 0)
                            .animation(.spring(), value: selection)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 230)
                            .padding(.horizontal, 16)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // we do custom dots
            
            // Custom dots
            HStack(spacing: 6) {
                ForEach(viewModel.promos.indices, id: \.self) { index in
                    Circle()
                        .frame(width: selection == index ? 10 : 6,
                               height: selection == index ? 10 : 6)
                        .opacity(selection == index ? 1.0 : 0.3)
                        .animation(.easeInOut, value: selection)
                }
            }
            .foregroundColor(.primary)
        }
        .frame(maxHeight: 250)
    }
}
