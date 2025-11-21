import SwiftUI

// MARK: Detauk of the chosen Item with description and Nutritions

struct MenuItemDetail: View {
    var item: MenuItemModel
    private let imageSize: CGFloat = 150
    private let cornerRadius: CGFloat = 16
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Image(.itemBackground)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                
                imageView
                    .padding(.top, 80)
            }
            .frame(height: 250)
            Divider()
                .padding()
            
           
                // MARK: - Tags + Milk options in one line
                HStack(spacing: 14) {
                    // 1) Dietary tags (Parve / Dairy / Vegan / Gluten-Free)
                    if let tags = item.dietaryTags {
                        ForEach(tags, id: \.self) { tag in
                            Image(tag.imageName)
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }

                    // 2) Milk options (Regular / Soy / Oat etc.)
                    if let milkOptions = item.milkOptions {
                        ForEach(milkOptions, id: \.self) { milk in
                            Image(milk.imageName)
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 8)
            Divider()
                .padding()
            ScrollView {
                // MARK: - Title & description
                Text(item.name)
                    .font(.title)
                    .foregroundStyle(.primaryText)

                Text(item.description ?? "Item Description")
                    .font(.headline)
                    .foregroundStyle(.primaryText)
                    .padding()
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .top)
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



