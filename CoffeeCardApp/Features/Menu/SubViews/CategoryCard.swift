import SwiftUI

// MARK: Menu Category icons and buttons
struct CategoryCard: View {
    let category: CatalogTypeModel

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(category.categoryImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipped()
                )

            Text(category.title)
                .font(.subheadline)
                .foregroundStyle(.primaryText)
        }
        .padding(12)
    }
}
