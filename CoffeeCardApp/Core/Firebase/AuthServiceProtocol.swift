import FirebaseAuth

protocol AuthServiceProtocol {
    var currentAuthUser: FirebaseAuth.User? {get}
    func signIn(email: String, password: String) async throws -> FirebaseAuth.User
    func signUp(email: String, password: String) async throws -> FirebaseAuth.User
    func signOut() throws
}
