import SwiftUI

struct QrDetailView: View {
    @EnvironmentObject private var session: SessionViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var qrPayload: String? {
        guard let id = session.user?.id else { return nil }
        return "coffeecard:user:\(id)"
    }
    
    var body: some View {
        ZStack {
            Color.backgroundApp
                .ignoresSafeArea()
            
            if let payload = qrPayload,
               let qrImage = QRCodeGenerator().generate(from: payload) {
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16.ds, weight: .semibold))
                                .padding(10.ds)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 10.ds)
                    
                    qrCard(qrImage: qrImage, payload: payload, userID: qrPayload)
                    
                    Spacer()
                }
                
            } else {
                VStack(spacing: 12.ds) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 64.ds))
                        .foregroundColor(.secondary)
                    Text("Unable to generate QR")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Card
    
    private func qrCard(qrImage: UIImage, payload: String, userID: String?) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32.ds)
                .fill(Color.black.opacity(0.92))
                .shadow(color: .black.opacity(0.35),
                        radius: 30.ds, x: 0, y: 22.ds)
            
            VStack(spacing: 20.ds) {
                Text("Show this QR to scan")
                    .font(.appSubtitle)
                    .foregroundColor(Color.white.opacity(0.75))
                    .padding(.top, 16.ds)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 24.ds)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.25),
                                radius: 18.ds, x: 0, y: 10.ds)
                        .frame(width: 220.ds, height: 220.ds)
                    
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190.ds, height: 190.ds)
                }
                if let id = userID {
                    let last4 = String(id.suffix(4))
                    Text("••••••\(last4)")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.appSubtitle)
                } else {
                    Text("••••••••••••")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.appSubtitle)
                }
                buttonsRow(payload: payload)
                    .padding(.bottom, 10.ds)
            }
            .padding(.horizontal, 24.ds)
            .padding(.vertical, 18.ds)
        }
        .frame(width: 300.ds, height: 420.ds)
    }
    
    // MARK: - Buttons row
    
    private func buttonsRow(payload: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.ds)
                .fill(.ultraThinMaterial)
                .stroke(.accentApp, style: StrokeStyle())
            ShareLink(item: payload) {
                Image(systemName: "square.and.arrow.up")
                Text("Share ID")
            }
            .font(.appBody)
            .foregroundColor(.accentApp)
        }
        .frame(width: 150.ds, height: 40.ds)
    }
}
