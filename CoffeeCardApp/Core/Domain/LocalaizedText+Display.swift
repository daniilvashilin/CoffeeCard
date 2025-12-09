import Foundation

// MARK: Localaized Helper
extension LocalizedText {
    func text(for locale: Locale) -> String? {
        let code = locale.language.languageCode?.identifier ?? "en"
        switch code {
        case "he": return he ?? en ?? ru
        case "ru": return ru ?? en ?? he
        default:   return en ?? he ?? ru
        }
    }
}
