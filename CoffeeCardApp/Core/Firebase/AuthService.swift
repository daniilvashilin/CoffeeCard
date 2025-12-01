import FirebaseAuth

final class AuthService: AuthServiceProtocol {

    var currentAuthUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    
    func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user
        } catch {
            throw mapAuthError(error)
        }
    }

    func signUp(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw mapAuthError(error)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw mapAuthError(error)
        }
    }

    // MARK: - Private Mapper
    private func mapAuthError(_ error: Error) -> AuthError {
        let ns = error as NSError
        
        guard let code = AuthErrorCode(rawValue: ns.code) else {
            return .unknown
        }
        
        switch code {
        case .wrongPassword, .invalidCredential:
            return .invalidCredentials
            
        case .userNotFound:
            return .userNotFound
            
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
            
        case .weakPassword:
            return .weakPassword
            
        case .networkError:
            return .network
            
        default:
            return .unknown
        }
    }
}
