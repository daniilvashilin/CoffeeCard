import SwiftUI

struct PromoBannerCard: View {
    let imageURL: String

    @State private var isImageVisible = false
    @State private var showShimmer = false   // ← показывать ли shimmer

    var body: some View {
        ZStack {
            // Фон-карта
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("backgroundApp"),
                            Color("secondaryApp").opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    if showShimmer && !isImageVisible {
                        ShimmerView()
                            .mask(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                            )
                            .transition(.opacity)
                    }
                }

            // Картинка
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    Color.clear   // фон + shimmer уже работают
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .opacity(isImageVisible ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isImageVisible = true
                            }
                        }
                case .failure:
                    Image(systemName: "wifi.exclamationmark")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.8))
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .frame(height: 230)
        .clipped()
        .shadow(radius: 8, y: 4)
        .onAppear {
            // маленькая задержка перед запуском shimmer
            // если картинка успеет загрузиться раньше — shimmer вообще не появится
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                if !isImageVisible {
                    withAnimation(.easeIn(duration: 0.25)) {
                        showShimmer = true
                    }
                }
            }
        }
    }
}
