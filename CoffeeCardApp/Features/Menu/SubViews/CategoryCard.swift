import SwiftUI

// MARK: Menu Category icons and buttons
struct CategoryCard: View {
    let category: CatalogTypeModel

    private let baseContainer: CGFloat = 80
    private let baseIcon: CGFloat = 48
    private let baseCorner: CGFloat = 24
    private let baseSpacing: CGFloat = 8
    private let basePadding: CGFloat = 12

    var body: some View {
        VStack(spacing: baseSpacing.ds) {
            RoundedRectangle(cornerRadius: baseCorner.ds)
                .fill(Color(.secondarySystemBackground))
                .frame(width: baseContainer.ds, height: baseContainer.ds)
                .overlay(
                    Image(category.categoryImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: baseIcon.ds, height: baseIcon.ds)
                )

            Text(category.title)
                .font(.subheadline)
                .foregroundStyle(.primaryText)
                .multilineTextAlignment(.center)
        }
        .padding(basePadding.ds)
    }
}
