import SwiftUI

struct HighlightImageStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxHeight: 200)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Image {
    func highlightImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .modifier(HighlightImageStyle())
    }
}
