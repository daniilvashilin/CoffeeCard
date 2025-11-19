import SwiftUI

struct LoyaltyQRCardView: View {
    @State private var model = LoyaltyQRModel(
        uid: "uid_7d73d2f5-2a8c-4b1a-8c6b-93bf15f4a9b1" // ← dummy for now. Replace with real UID later.
    )

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack() {
                Image(systemName: "cup.and.saucer.fill")
                    .imageScale(.large)
                Text("KakaoExpress • Loyalty")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)

            // QR itself
            Group {
                if let img = model.qrImage {
                    img
                        .resizable()
                        .interpolation(.none)      // critical to keep modules sharp
                        .antialiased(false)
                        .scaledToFit()
                        .frame(width: 240, height: 240) // tweak as you like
                        .padding(12) // quiet zone around QR so scanners don't cry
                        .background(.accentApp)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    // Fallback in the unlikely event the QR fails to render
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(.secondary.opacity(0.15))
                        .frame(width: 240, height: 240)
                        .overlay(
                            VStack(spacing: 8) {
                                ProgressView()
                                Text("Generating QR…").font(.footnote)
                            }
                            .foregroundStyle(.white)
                        )
                }
            }

            // Friendly instructions for the barista
            VStack(spacing: 4) {
                Text("Show this code to the barista")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Text(model.maskedUID)
                    .font(.footnote.monospaced())
                    .foregroundStyle(.white)
            }

            // Handy controls for your testing
            HStack(spacing: 12) {

                ShareLink(item: model.uid, preview: SharePreview("KakaExpress Loyalty QR", image: snapshotQR()))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.bordered)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.accentApp)
        )
        .padding()
    }

    // Renders a temporary image for SharePreview thumbnail
    private func snapshotQR() -> Image {
        if let cg = QRCode.make(from: model.uid) {
            return Image(decorative: cg, scale: 1, orientation: .up)
        }
        return Image(systemName: "qrcode")
    }
}

// MARK: - Preview

#Preview("Loyalty QR Card") {
    LoyaltyQRCardView()
        .preferredColorScheme(.light)
        .frame(maxWidth: 420)
        .padding()
}
