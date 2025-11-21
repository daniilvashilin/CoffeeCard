import SwiftUI

struct PromoCarouselView: View {
    @ObservedObject var promoViewModel: PromoViewModel
    @State private var selection: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            if promoViewModel.isLoading && promoViewModel.promos.isEmpty {
                ProgressView("Loading promos…")
                    .frame(height: 250)
                    .padding(.horizontal, 16)
            }
            else if let error = promoViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            else if promoViewModel.promos.isEmpty {
                Text("No promos yet")
                    .foregroundColor(.secondary)
            }
            else {
                carousel
            }
        }
        .padding(.vertical, 24)
        .task {
            await promoViewModel.loadPromos()
        }
}

    
    // MARK: - Carousel view
    
    private var carousel: some View {
        VStack(spacing: 12) {
            TabView(selection: $selection) {
                ForEach(Array(promoViewModel.promos.enumerated()), id: \.element.id) { index, promo in
                    PromoBannerCard(imageURL: promo.imageURL)
                        .padding(.horizontal, 16)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // dots те же
            HStack(spacing: 6) {
                ForEach(promoViewModel.promos.indices, id: \.self) { index in
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

