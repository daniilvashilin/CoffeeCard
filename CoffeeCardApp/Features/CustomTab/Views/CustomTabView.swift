import SwiftUI

struct CustomTabView: View {
    var width: CGFloat

    @Binding var selection: CustomTabModel
    let tabs: [CustomTabModel]

    private let metrics = TabBarMetrics.current

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: metrics.cornerRadius)
                .fill(Color.secondaryApp)
                .frame(width: width, height: metrics.barHeight)

            HStack {
                ForEach(tabs) { tab in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            selection = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: selection == tab ? tab.filledIcon : tab.tabIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                                .contentTransition(.symbolEffect(.replace))
                                .symbolEffect(.bounce, value: selection == tab)
                                .scaleEffect(selection == tab ? 1.12 : 1.0)
                                .foregroundColor(selection == tab ? .tabBarIconActive : .tabBarIcon)

                            Text(tab.titile)
                                .foregroundColor(selection == tab ? .tabBarLabelActive : .tabBarLabel)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, metrics.horizontalPadding)
            .padding(.vertical, metrics.verticalPadding)
        }
    }
}
