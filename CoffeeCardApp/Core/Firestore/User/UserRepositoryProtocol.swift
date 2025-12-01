import FirebaseFirestore
import FirebaseAuth

protocol UserRepositoryProtocol {
    func getUser(withId id: String) async throws -> User?
    func createUserIfNeeded(from authUser: FirebaseAuth.User) async throws -> User
    func updateUser(_ user: User) async throws
}
