import SwiftUI

struct MenuItemCard: View {
    private let baseImageSize: CGFloat = 80
    private let baseCornerRadius: CGFloat = 16
    private let basePadding: CGFloat = 12

    var item: MenuItemModel
    
    var body: some View {
        let imageSize = baseImageSize.ds
        let cornerRadius = baseCornerRadius.ds
        let padding = basePadding.ds
        
        VStack(alignment: .center, spacing: 8.ds) {
            imageView(imageSize: imageSize, cornerRadius: cornerRadius)
            titleView(maxWidth: imageSize)
        }
        .padding(padding)
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private func imageView(imageSize: CGFloat, cornerRadius: CGFloat) -> some View {
        if item.imageURL != nil {
            CachedMenuImageView(
                urlString: item.imageURL,
                size: imageSize,
                cornerRadius: cornerRadius
            )
        } else {
            placeholderImage(imageSize: imageSize, cornerRadius: cornerRadius)
        }
    }
    
    private func shimmerPlaceholder(imageSize: CGFloat, cornerRadius: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.15))
            
            SmallShimmerDiagonal()
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: imageSize, height: imageSize)
                )
        }
        .frame(width: imageSize, height: imageSize)
    }
    
    private func placeholderImage(imageSize: CGFloat, cornerRadius: CGFloat) -> some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageSize, height: imageSize)
            .foregroundColor(.secondary)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.1))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    // MARK: - Title
    
    private func titleView(maxWidth: CGFloat) -> some View {
        Text(item.name)
            .font(.system(size: 11.ds, weight: .medium))
            .foregroundStyle(.primaryText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: maxWidth)
            .lineLimit(2)
            .minimumScaleFactor(0.9)
            .fixedSize(horizontal: false, vertical: true)
    }
}
