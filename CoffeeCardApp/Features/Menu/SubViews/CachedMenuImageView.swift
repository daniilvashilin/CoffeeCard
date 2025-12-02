import SwiftUI

struct CachedMenuImageView: View {
    let urlString: String?
    let size: CGFloat
    let cornerRadius: CGFloat
    
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.15))
                    
                    SmallShimmerDiagonal()
                        .mask(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .frame(width: size, height: size)
                        )
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .task {
            await loadImageIfNeeded()
        }
    }
    
    @MainActor
    private func loadImageIfNeeded() async {
        guard uiImage == nil else { return }
        guard let urlString, let url = URL(string: urlString) else { return }
        guard !isLoading else { return }
        
        // 1. cache first
        if let cached = MenuImageCache.shared.image(for: url) {
            uiImage = cached
            return
        }
        
        // 2. load from network / URLCache
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                MenuImageCache.shared.insert(image, for: url)
                uiImage = image
            }
        } catch {
            Log.error("Failed to load image from \(urlString)", error)
        }
    }
}
