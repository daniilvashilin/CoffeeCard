import SwiftUI

struct MilkBaseSelector: View {
    let milkOptions: [MilkType]?
    @Binding var selectedMilkOption: MilkType?
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Milk Base:")
                    .font(.caption)
                    .foregroundStyle(.primaryText)
                Text(selectedMilkOption?.title ?? "Unknown")
                    .font(.subheadline.bold())
                    .foregroundStyle(selectedMilkOption?.milkTypeColor ?? .primaryText)
                    .lineLimit(1)
            }
            .frame(width: 110, alignment: .leading)
            
            HStack(spacing: 10) {
                if let milkOptions, !milkOptions.isEmpty {
                    ForEach(milkOptions, id: \.self) { milk in
                        Button {
                            selectedMilkOption = milk
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(milk.milkTypeColor)
                                    .frame(width: 38, height: 38)
                                Image(milk.imageName)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .scaleEffect(selectedMilkOption == milk ? 1.1 : 0.9)
                            .opacity(selectedMilkOption == milk ? 1 : 0.7)
                        }
                    }
                } else {
                    ZStack {
                        Circle()
                            .fill(.primaryText)
                            .stroke(.red)
                            .frame(width: 38, height: 38)
                        Image(systemName: "nosign")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
