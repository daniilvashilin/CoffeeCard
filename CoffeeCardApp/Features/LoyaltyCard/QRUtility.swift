import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


enum QRCode {
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()

    /// Generates a CGImage for a given string. Use .interpolation(.none) when displaying.
    static func make(from string: String, correctionLevel: String = "M") -> CGImage? {
        filter.setValue(Data(string.utf8), forKey: "inputMessage")
        filter.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }

        // Scale up the CIImage to a reasonable base size without interpolation.
        // We scale in Core Image space to keep modules sharp.
        let desiredBaseSize: CGFloat = 512 // logical pixels; UI will size it further
        let extent = output.extent.integral
        let scale = min(desiredBaseSize / extent.width, desiredBaseSize / extent.height)
        let scaled = output.transformed(by: .init(scaleX: scale, y: scale))

        return QRCode.context.createCGImage(scaled, from: scaled.extent)
    }
}
