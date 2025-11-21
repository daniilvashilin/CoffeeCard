import SwiftUI

// MARK: Items inside the catalog category
// for example ColdDrrink -> (Amerciano) -> MenuItemDetailView

struct CategoryItemsView: View {
    let category: CatalogTypeModel
    @ObservedObject var viewModel: MenuViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.items(for: category)) { item in
                    NavigationLink {
                        MenuItemDetail(item: item)
                    } label: {
                        MenuItemCard(item: item)
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
