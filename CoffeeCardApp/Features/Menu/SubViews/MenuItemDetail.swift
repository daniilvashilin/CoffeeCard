import SwiftUI

// MARK: - Detail of the chosen item with description and nutritions

struct MenuItemDetail: View {
    @Environment(\.dismiss) private var dismiss
    
    let item: MenuItemModel
    @Binding var isTabBarHidden: Bool
    private let imageSize: CGFloat = 150
    private let cornerRadius: CGFloat = 16
    
    @State private var selectedMilkOption: MilkType?
    @State private var selectedSize: DrinkSize?
    @State private var quantity: Int = 1
    @State private var isCartSheetPresented: Bool = false
    
    private let priceTier: PriceTier = .regular
    
    init(item: MenuItemModel, isTabBarHidden: Binding<Bool>) {
        self.item = item
        _isTabBarHidden = isTabBarHidden
        
        _selectedMilkOption = State(initialValue: item.milkOptions?.first ?? .regular)
        _selectedSize = State(initialValue: nil)
    }
    
    private var unitPriceAgorot: Int {
        item.price(
            tier: priceTier,
            size: selectedSize,
            milk: selectedMilkOption,
            sideMilk: nil
        )
    }
    
    private var totalPriceAgorot: Int {
        unitPriceAgorot * max(quantity, 1)
    }
    
    private var totalPriceText: String {
        totalPriceAgorot.asShekelString()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                MenuItemHeaderView(
                    item: item,
                    imageSize: imageSize,
                    cornerRadius: cornerRadius,
                    kosherTag: item.kosherTag(for: selectedMilkOption)
                )
                
                // MARK: - Options (milk & size)
                VStack(alignment: .leading, spacing: 18) {
                    MilkBaseSelector(
                        milkOptions: item.milkOptions,
                        selectedMilkOption: $selectedMilkOption
                    )
                    
                    SizeSelectorView(
                        sizeOptions: item.drinkSizeOptions,
                        selectedSize: $selectedSize
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 8)
                .appBackground()
                
                Divider()
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(item.name)
                            .font(.title)
                            .foregroundStyle(.primaryText)
                        
                        Text(item.description ?? "Item Description")
                            .font(.headline)
                            .foregroundStyle(.primaryText)
                            .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .scrollContentBackground(.hidden)
                .background(Color.backgroundApp)
            }
            .ignoresSafeArea(edges: .top)
        }
        .onAppear {
            isTabBarHidden = true
        }
        .safeAreaInset(edge: .bottom) {
            AddToCartBar(
                priceText: totalPriceText,
                quantity: $quantity,
                itemsInCart: 0,
                onAddToCart: addToCart,
                onCartTap: { isCartSheetPresented = true }
            )
            .padding(.top, 8)
            .padding(.bottom, 8)
            .background(Color.backgroundApp)
        }
        .sheet(isPresented: $isCartSheetPresented) {
            CartPlaceholderView()
        }
    }
    
    private func addToCart() {
        print("Add to cart tapped, total price: \(totalPriceText)")
        withAnimation(.spring()) {
            dismiss()
        }
    }
}
