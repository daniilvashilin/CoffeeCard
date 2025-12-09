import Foundation
// MARK: - Int + Currency

extension NumberFormatter {
    static let shekelFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "ILS"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        return f
    }()
}
