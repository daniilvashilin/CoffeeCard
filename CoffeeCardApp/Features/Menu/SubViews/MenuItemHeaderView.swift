import SwiftUI

struct MenuItemHeaderView: View {
    let item: MenuItemModel
    let imageSize: CGFloat      
    let cornerRadius: CGFloat
    let kosherTag: DietaryTag?
    
    
    private let baseHeaderHeight: CGFloat = 250
    private let baseImageTopOffset: CGFloat = 80
    private let baseKosherSize: CGFloat = 46
    private let baseKosherPadding: CGFloat = 16
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.itemBackground)
                .resizable()
                .scaledToFill()
                .frame(height: baseHeaderHeight.ds)
                .clipped()
            
            imageView
                .padding(.top, baseImageTopOffset.ds)
            
            VStack {
                Spacer()
                HStack {
                    if let kosherTag {
                        Image(kosherTag.imageName)
                            .resizable()
                            .frame(
                                width: baseKosherSize.ds,
                                height: baseKosherSize.ds
                            )
                            .padding(.leading, baseKosherPadding.ds)
                            .padding(.bottom, baseKosherPadding.ds)
                    }
                    Spacer()
                }
            }
        }
        .frame(height: baseHeaderHeight.ds)
    }
    
    // MARK: - Image
    
    @ViewBuilder
    private var imageView: some View {
        if item.imageURL != nil {
            CachedMenuImageView(
                urlString: item.imageURL,
                size: imageSize.ds,
                cornerRadius: cornerRadius.ds
            )
        } else {
            placeholderImage
        }
    }
    private var shimmerPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius.ds)
                .fill(Color.gray.opacity(0.15))
            
            SmallShimmerDiagonal()
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius.ds)
                        .frame(width: imageSize.ds, height: imageSize.ds)
                )
        }
        .frame(width: imageSize.ds, height: imageSize.ds)
    }
    
    private var placeholderImage: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: imageSize.ds, height: imageSize.ds)
            .foregroundColor(.secondary)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius.ds)
                    .fill(Color.gray.opacity(0.1))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius.ds))
    }
    
    // MARK: - Title
    private var titleView: some View {
        Text(item.name)
            .font(.caption)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: imageSize.ds)
            .lineLimit(2)
            .minimumScaleFactor(0.9)
            .fixedSize(horizontal: false, vertical: true)
    }
}
