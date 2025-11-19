import SwiftUI

struct MenuView: View {
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
                                              viewModel: viewModel)
                        } label: {
                            CategoryCard(category: category)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle("Menu")
            .task {
                await viewModel.loadMenu()      // <-- important
            }
        }
    }
}

#Preview {
    MenuView()
}

