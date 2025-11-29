import SwiftUI

// MARK: - Detail of the chosen item with description and nutritions

struct MenuItemDetail: View {
    let item: MenuItemModel
    private let imageSize: CGFloat = 150
    private let cornerRadius: CGFloat = 16
    
    @State private var selectedMilkOption: MilkType?
    @State private var selectedSize: DrinkSize?
    
    init(item: MenuItemModel) {
        self.item = item
        _selectedMilkOption = State(initialValue: item.milkOptions?.first ?? .regular)
        _selectedSize = State(initialValue: nil)
    }
    var body: some View {
        VStack(spacing: 0) {
            MenuItemHeaderView(
                item: item,
                imageSize: imageSize,
                cornerRadius: cornerRadius,
                kosherTag: item.kosherTag(for: selectedMilkOption)
            )
            
            // MARK: - Options (milk & size)
            VStack(alignment: .leading, spacing: 18) {
                // Milk option
                MilkBaseSelector(milkOptions: item.milkOptions, selectedMilkOption: $selectedMilkOption)
                
                // Size option
                SizeSelectorView(sizeOptions: item.drinkSizeOptions, selectedSize: $selectedSize)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.bottom, 8)
            
            
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
        }
        .ignoresSafeArea(edges: .top)
    }
}



