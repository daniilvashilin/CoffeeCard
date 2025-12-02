import SwiftUI

enum DeviceWidthClass {
    case compactPhone    // Basic 13/14/15/16, SE ...
    case widePhone       // Plus / Pro Max
    case other           // iPad / Mac ...

    static var current: DeviceWidthClass {
        let w = UIScreen.main.bounds.width
        if w >= 428 {        // Width as Plus / Pro Max
            return .widePhone
        } else if w >= 320 {
            return .compactPhone
        } else {
            return .other
        }
    }
}

struct TabBarMetrics {
    let barHeight: CGFloat
    let containerHeight: CGFloat
    let cornerRadius: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat

    static var current: TabBarMetrics {
        switch DeviceWidthClass.current {
        case .widePhone:
            return .init(
                barHeight: 72,
                containerHeight: 80,
                cornerRadius: 40,
                horizontalPadding: 20,
                verticalPadding: 8
            )
        case .compactPhone, .other:
            return .init(
                barHeight: 64,
                containerHeight: 72,
                cornerRadius: 36,
                horizontalPadding: 16,
                verticalPadding: 6
            )
        }
    }
}

enum DeviceMetrics {
    static var scale: CGFloat {
        let h = UIScreen.main.bounds.height

        switch h {
        case ..<736:        // SE, 8
            return 0.8
        case 736..<844:
            return 0.9
        case 844..<926:     // 15/16, 14 Pro
            return 0.93
        default:            // Pro Max
            return 1.0
        }
    }
}

extension CGFloat {
    var ds: CGFloat {
        self * DeviceMetrics.scale
    }
}

extension BinaryInteger {
    var ds: CGFloat {
        CGFloat(self) * DeviceMetrics.scale
    }
}
