import Foundation

enum UserRepositoryError: LocalizedError {
    case userNotFound
    case permissionDenied
    case unauthenticated
    case network
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User profile not found."
        case .permissionDenied:
            return "You don’t have permission to access this user."
        case .unauthenticated:
            return "Please sign in to continue."
        case .network:
            return "Network error. Please check your connection."
        case .decoding:
            return "Failed to read your profile data."
        case .unknown:
            return "Something went wrong with your profile."
        }
    }
}
