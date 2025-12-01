import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case network
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email or password is incorrect."
        case .emailAlreadyInUse:
            return "An account with this email already exists."
        case .weakPassword:
            return "Password is too weak. Try a stronger one."
        case .userNotFound:
            return "No user found with this email."
        case .network:
            return "Network error. Please check your connection."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

