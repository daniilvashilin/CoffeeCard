import SwiftUI

// MARK: Detauk of the chosen Item with description and Nutritions

struct MenuItemDetail: View {
    var item: MenuItemModel
    private let imageSize: CGFloat = 150
    private let cornerRadius: CGFloat = 16
    @State private var selectedMilkOption: MilkType? = .regular
    @State private var selectedSize: DrinkSize? = Optional.none
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
                
                VStack {
                    Spacer()
                    HStack {
                        if let tag = currentKosherTag() {
                            Image(tag.imageName)
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
            Divider()
                .padding()
            
            
            // MARK: - Tags + Milk options in one line
            VStack(alignment: .leading, spacing: 18) {
                // MARK: MILK OPTION UI
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Milk Base:")
                            .font(.caption)
                            .foregroundStyle(.primaryText)
                        Text(selectedMilkOption?.title ?? "Unknown")
                            .font(.subheadline.bold())
                            .foregroundStyle(selectedMilkOption?.milkTypeColor ?? .primaryText)
                            .lineLimit(1)
                    }
                    .frame(width: 110, alignment: .leading)
                    
                    HStack(spacing: 10) {
                        if let milkOptions = item.milkOptions, !milkOptions.isEmpty {
                            ForEach(milkOptions, id: \.self) { milk in
                                Button {
                                    selectedMilkOption = milk
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(milk.milkTypeColor)
                                            .frame(width: 38, height: 38)
                                        Image(milk.imageName)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    .scaleEffect(selectedMilkOption == milk ? 1.1 : 0.9)
                                    .opacity(selectedMilkOption == milk ? 1 : 0.7)
                                }
                            }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(.primaryText)
                                    .stroke(.red)
                                    .frame(width: 38, height: 38)
                                Image(systemName: "nosign")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                // MARK: SIZE OPTION UI
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Selected Size:")
                            .font(.caption)
                            .foregroundStyle(.primaryText)
                        Text(selectedSize?.secondTitle ?? "None")
                            .font(.subheadline.bold())
                            .foregroundStyle(selectedMilkOption?.milkTypeColor ?? .primaryText)
                            .lineLimit(1)
                    }
                    .frame(width: 110, alignment: .leading)
                    
                    HStack(spacing: 14) {
                        if let sizeOptions = item.DrinkSizeOptions, !sizeOptions.isEmpty {
                            ForEach(sizeOptions, id: \.self) { size in
                                Button {
                                    selectedSize = size
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(.primaryText)
                                            .frame(width: 38, height: 38)
                                        Text(size.title)
                                            .foregroundStyle(.buttonText)
                                            .font(.headline.bold())
                                    }
                                    .scaleEffect(selectedSize == size ? 1.1 : 0.9)
                                    .opacity(selectedSize == size ? 1 : 0.5)
                                }
                            }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(.primaryText)
                                    .stroke(.red)
                                    .frame(width: 38, height: 38)
                                Image(systemName: "nosign")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func currentKosherTag() -> DietaryTag? {
        guard let tags = item.dietaryTags else { return nil }
        
        let kosherTags = tags.filter { $0 == .dairy || $0 == .parve }
        guard !kosherTags.isEmpty else { return nil }
        
        if kosherTags.contains(.dairy) && kosherTags.contains(.parve) {
            guard let milk = selectedMilkOption else { return .dairy }
            
            switch milk {
            case .regular, .lactoseFree:
                return .dairy
            case .soy, .almond, .oat:
                return .parve
            }
        }
        
        if kosherTags.contains(.dairy) { return .dairy }
        if kosherTags.contains(.parve) { return .parve }
        
        return nil
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



