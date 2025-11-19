import SwiftUI

@Observable
final class LoyaltyQRModel {
    var uid: String

    init(uid: String) {
        self.uid = uid
    }

    var qrImage: Image? {
        guard let cg = QRCode.make(from: uid) else { return nil }
        return Image(decorative: cg, scale: 1, orientation: .up)
    }

    /// Masked UID for display (last 6 visible)
    var maskedUID: String {
        let keep = 6
        if uid.count <= keep { return uid }
        let suffix = uid.suffix(keep)
        return "•••••••••••\(suffix)"
    }
}
