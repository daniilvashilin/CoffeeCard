import SwiftUI

// MARK: Detauk of the chosen Item with description and Nutritions

struct MenuItemDetail: View {
    var item: MenuItemModel
    var body: some View {
        VStack {
            Image(.barMenue)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 200)
                .padding(.bottom)
            VStack {
                Text(item.name)
                    .font(.title).bold()
                Text(item.description ?? "Empty")
                    .font(.appBody)
            }
            .foregroundStyle(.primaryText)
            .padding()
                Spacer()
        }
        .ignoresSafeArea()
    }
}
