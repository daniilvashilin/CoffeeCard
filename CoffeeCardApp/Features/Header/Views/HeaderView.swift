import SwiftUI

struct HeaderView: View {
    @State private var showSheet: Bool = false
    var body: some View {
        HStack {
            Spacer()
            Button {
                showSheet = true
            } label: {
                Text("300")
                    .foregroundStyle(.primaryText)
                    .font(.appBody.bold())
                Image("coinImage")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.horizontal)
        }
        .padding(.top)
        .padding(.horizontal)
        .sheet(isPresented: $showSheet) {
            CoinsInfoView()
        }
    }
}

#Preview {
    HeaderView()
}
