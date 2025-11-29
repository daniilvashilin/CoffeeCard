import SwiftUI

struct MilkBaseSelector: View {
    let milkOptions: [MilkType]?
    @Binding var selectedMilkOption: MilkType?
    
    // MARK: - Base spacing
    private let baseOuterSpacing: CGFloat = 12
    private let baseCircleSize: CGFloat = 38
    private let baseImageSize: CGFloat = 24
    
    private var labelWidth: CGFloat {
        switch DeviceWidthClass.current {
        case .widePhone:     // Pro Max / Plus
            return 120.ds
        case .compactPhone:
            return 150.ds
        case .other:
            return 130.ds
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: baseOuterSpacing.ds) {
            
            // MARK: - LEFT INFO BLOCK
            VStack(alignment: .leading, spacing: 2.ds) {
                Text("Milk Base:")
                    .font(.caption)
                    .foregroundStyle(.primaryText)
                
                Text(selectedMilkOption?.title ?? "Unknown")
                    .font(.subheadline.bold())
                    .foregroundStyle(selectedMilkOption?.milkTypeColor ?? .primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)  
            }
            .frame(width: labelWidth, alignment: .leading)
            
            // MARK: - ICON LIST
            HStack(spacing: 10.ds) {
                if let milkOptions, !milkOptions.isEmpty {
                    ForEach(milkOptions, id: \.self) { milk in
                        Button {
                            selectedMilkOption = milk
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(milk.milkTypeColor)
                                    .frame(width: baseCircleSize.ds,
                                           height: baseCircleSize.ds)
                                
                                Image(milk.imageName)
                                    .resizable()
                                    .frame(width: baseImageSize.ds,
                                           height: baseImageSize.ds)
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
