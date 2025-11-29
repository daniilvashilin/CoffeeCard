import SwiftUI

struct MenuView: View {
    @Binding var isTabBarHidden: Bool
    @StateObject private var viewModel = MenuViewModel(
        repository: FirestoreMenuRepository()
    )

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(CatalogTypeModel.allCases) { category in
                        NavigationLink {
                            CategoryItemsView(category: category,
                                              viewModel: viewModel, isTabBarHidden: $isTabBarHidden)
                        } label: {
                            CategoryCard(category: category)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle("Menu")
            .scrollContentBackground(.hidden)   
            .background(Color.backgroundApp)
            .task {
                await viewModel.loadMenu()      // <-- important
            }
        }
    }
}


