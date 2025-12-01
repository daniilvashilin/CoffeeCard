import FirebaseFirestore
import FirebaseAuth
import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()
    private var usersCollection: CollectionReference {
        db.collection("users")
    }
    
    func getUser(withId id: String) async throws -> User? {
        do {
            let doc = try await usersCollection.document(id).getDocument()
            if doc.exists {
                do {
                    return try doc.data(as: User.self)
                } catch {
                    // decoding problem
                    throw UserRepositoryError.decoding
                }
            } else {
                return nil
            }
        } catch {
            throw mapFirestoreError(error)
        }
    }
    
    func createUserIfNeeded(from authUser: FirebaseAuth.User) async throws -> User {
        if let existing = try await getUser(withId: authUser.uid) {
            return existing
        }
        
        let newUser = User.newFromAuth(authUser: authUser)
        
        do {
            try usersCollection.document(authUser.uid).setData(from: newUser)
            return newUser
        } catch {
            throw mapFirestoreError(error)
        }
    }
    
    func updateUser(_ user: User) async throws {
        guard let id = user.id else { return }
        
        do {
            try usersCollection.document(id).setData(from: user, merge: true)
        } catch {
            throw mapFirestoreError(error)
        }
    }
    
    // MARK: - Private mapper
    
    private func mapFirestoreError(_ error: Error) -> UserRepositoryError {
        let ns = error as NSError

        if ns.domain == FirestoreErrorDomain,
           let code = FirestoreErrorCode.Code(rawValue: ns.code) {

            switch code {
            case .permissionDenied:
                return .permissionDenied
            case .unauthenticated:
                return .unauthenticated
            case .unavailable, .deadlineExceeded:
                return .network
            case .notFound:
                return .userNotFound
            case .dataLoss, .internal:
                return .decoding
            default:
                return .unknown
            }
        }

        return .unknown
    }
}
