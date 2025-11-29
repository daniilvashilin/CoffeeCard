import SwiftUI

// MARK: Items inside the catalog category
// for example ColdDrink -> (Americano) -> MenuItemDetailView

struct CategoryItemsView: View {
    let category: CatalogTypeModel
    @ObservedObject var viewModel: MenuViewModel
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        let gridSpacing: CGFloat = 16.ds
        let bottomPadding: CGFloat = 80.ds
        
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: gridSpacing),
                    GridItem(.flexible(), spacing: gridSpacing)
                ],
                spacing: gridSpacing
            ) {
                ForEach(viewModel.items(for: category)) { item in
                    NavigationLink {
                        MenuItemDetail(item: item, isTabBarHidden: $isTabBarHidden)
                    } label: {
                        MenuItemCard(item: item)
                    }
                }
            }
            .padding(.horizontal, 16.ds)
            .padding(.bottom, bottomPadding)
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundApp)
        .onAppear {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isTabBarHidden = false
            }
        }
    }
}
