import SwiftUI

struct CustomTabView: View {
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    
    @Binding var selection: CustomTabModel
    let tabs: [CustomTabModel]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.secondaryApp)
                .frame(width: width, height: height)
            HStack {
                ForEach(tabs) { tab in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            selection = tab
//                            UIImpactFeedbackGenerator(style: .medium).impactOccurred() Just Testing effect
                        }
                    } label: {
                        Spacer()
                        VStack {
                            Image(systemName: selection == tab ? tab.filledIcon : tab.tabIcon)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .contentTransition(.symbolEffect(.replace))
                                .symbolEffect(.bounce, value: selection == tab)
                                .scaleEffect(selection == tab ? 1.12 : 1.0)
                                .foregroundColor(selection == tab ? .tabBarIconActive : .tabBarIcon)
                            Text(tab.titile)
                                .foregroundColor(selection == tab ? .tabBarLabelActive : .tabBarLabel)
                                .font(.caption)
                        }
                            Spacer()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CustomTabView(
        width: 350, height: 100, cornerRadius: 20,
        selection: .constant(.home),
        tabs: CustomTabModel.allCases
    )
}
