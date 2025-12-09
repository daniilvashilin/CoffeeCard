import Foundation

enum ValidationError: LocalizedError, Identifiable {
    case emptyName
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case weakPassword
    case passwordsDontMatch

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Please enter your name."
        case .emptyEmail:
            return "Please enter your email."
        case .invalidEmail:
            return "Email format looks incorrect."
        case .emptyPassword:
            return "Please enter a password."
        case .weakPassword:
            return "Password is too weak. Use at least 8 characters, letters and numbers."
        case .passwordsDontMatch:
            return "Passwords do not match."
        }
    }
}
