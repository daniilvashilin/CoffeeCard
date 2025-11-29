import SwiftUI

enum Log {
    static func info(_ message: String) {
#if DEBUG
        print("ℹ️", message)
#endif
    }

    static func error(_ message: String, _ error: Error? = nil) {
#if DEBUG
        if let error {
            print("❌", message, "-", error.localizedDescription)
        } else {
            print("❌", message)
        }
#endif
    }
}


extension View {
    func debugLog(_ message: String) -> some View {
        #if DEBUG
        print(message)
        #endif
        return self
    }
}
