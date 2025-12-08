import SwiftUI
import UniformTypeIdentifiers

struct QRShareImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { value in
            value.image.pngData()!
        }
    }
}
