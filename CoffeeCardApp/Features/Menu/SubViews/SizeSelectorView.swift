import SwiftUI

struct SizeSelectorView: View {
    var sizeOptions: [DrinkSize]?
    @Binding var selectedSize: DrinkSize?
    
    // MARK: Base settings
    private let baseOuterSpacing: CGFloat = 12
    private let baseCircleSize: CGFloat = 38
    
    private var labelWidth: CGFloat {
        switch DeviceWidthClass.current {
        case .widePhone:
            return 120.ds
        case .compactPhone:
            return 150.ds
        case .other:
            return 130.ds
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: baseOuterSpacing.ds) {
            
            // LEFT INFO TEXT
            VStack(alignment: .leading, spacing: 2.ds) {
                Text("Selected Size:")
                    .font(.caption)
                    .foregroundStyle(.primaryText)
                
                Text(selectedSize?.secondTitle ?? "None")
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .frame(width: labelWidth, alignment: .leading)
            
            // SIZE OPTIONS
            HStack(spacing: 14.ds) {
                if let sizeOptions, !sizeOptions.isEmpty {
                    ForEach(sizeOptions, id: \.self) { size in
                        Button {
                            selectedSize = size
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.primaryText)
                                    .frame(width: baseCircleSize.ds,
                                           height: baseCircleSize.ds)
                                
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
                            .frame(width: baseCircleSize.ds,
                                   height: baseCircleSize.ds)
                        
                        Image(systemName: "nosign")
                            .font(.system(size: 24.ds, weight: .bold))
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.horizontal, 4.ds)
    }
}
