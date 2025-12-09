import SwiftUI
import Foundation

struct ImageTitle: View {
    var body: some View {
        Image(.logoLaunch)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 150)
    }
}
