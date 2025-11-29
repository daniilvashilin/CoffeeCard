import SwiftUI

struct SizeSelectorView: View {
    var sizeOptions: [DrinkSize]?
    @Binding var selectedSize: DrinkSize?
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Selected Size:")
                    .font(.caption)
                    .foregroundStyle(.primaryText)
                Text(selectedSize?.secondTitle ?? "None")
                    .font(.subheadline.bold())
                    
                    .lineLimit(1)
            }
            .frame(width: 110, alignment: .leading)
            
            HStack(spacing: 14) {
                if let sizeOptions, !sizeOptions.isEmpty {
                    ForEach(sizeOptions, id: \.self) { size in
                        Button {
                            selectedSize = size
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.primaryText)
                                    .frame(width: 38, height: 38)
                                Text(size.title)
                                    .foregroundStyle(.buttonText)
                                    .font(.headline.bold())
                            }
                            .scaleEffect(selectedSize == size ? 1.1 : 0.9)
                            .opacity(selectedSize == size ? 1 : 0.5)
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

