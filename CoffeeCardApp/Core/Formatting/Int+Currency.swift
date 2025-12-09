import Foundation

extension Int {
    func asShekelString() -> String {
        let value = Double(self) / 100.0
        return NumberFormatter.shekelFormatter.string(from: NSNumber(value: value)) ?? "₪\(value)"
    }
}
