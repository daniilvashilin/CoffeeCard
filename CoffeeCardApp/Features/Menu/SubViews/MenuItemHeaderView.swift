import SwiftUI

struct MenuItemHeaderView: View {
    let item: MenuItemModel
    let imageSize: CGFloat
    let cornerRadius: CGFloat
    let kosherTag: DietaryTag?
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.itemBackground)
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .clipped()
            
            imageView
                .padding(.top, 80)
            
            VStack {
                Spacer()
                HStack {
                    if let kosherTag {
                        Image(kosherTag.imageName)
                            .resizable()
                            .frame(width: 46, height: 46)
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                    }
                    Spacer()
                }
            }
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let urlString = item.imageURL,
           let url = URL(string: urlString) {
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    shimmerPlaceholder
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    
                case .failure:
                    placeholderImage
                    
                @unknown default:
                    placeholderImage
                }
            }
        } else {
            placeholderImage
        }
    }
    private var shimmerPlaceholder: some View {
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
    
    private var placeholderImage: some View {
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
    
    private var titleView: some View {
        Text(item.name)
            .font(.caption)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: imageSize)
            .lineLimit(2)
            .minimumScaleFactor(0.9)
            .fixedSize(horizontal: false, vertical: true)
    }
}
