import SwiftUI
import FirebaseAuth

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(
        authService: AuthServiceProtocol = AuthService(),
        userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.authService = authService
        self.userRepository = userRepository
        
        Task {
            await loadCurrentUserIfLoggedIn()
        }
    }
    
    // MARK: - Load existing session
    
    private func loadCurrentUserIfLoggedIn() async {
        guard let authUser = authService.currentAuthUser else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let appUser = try await userRepository.createUserIfNeeded(from: authUser)
            self.user = appUser
        } catch let authError as AuthError {
            self.errorMessage = authError.localizedDescription
        } catch let repoError as UserRepositoryError {
            self.errorMessage = repoError.localizedDescription
        } catch {
            self.errorMessage = "Unexpected error. Please try again."
        }
    }
    
    // MARK: - Sign in
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let authUser = try await authService.signIn(email: email, password: password)
            let appUser = try await userRepository.createUserIfNeeded(from: authUser)
            self.user = appUser
        } catch let authError as AuthError {
            self.errorMessage = authError.localizedDescription
        } catch let repoError as UserRepositoryError {
            self.errorMessage = repoError.localizedDescription
        } catch {
            self.errorMessage = "Unexpected error. Please try again."
        }
    }
    
    // MARK: - Sign up
    
    func signUp(email: String, password: String, name: String?) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let authUser = try await authService.signUp(email: email, password: password)
            
            let appUser = User.newFromAuth(authUser: authUser, name: name)
            
            try await userRepository.updateUser(appUser)
            
            self.user = appUser
        } catch let authError as AuthError {
            self.errorMessage = authError.localizedDescription
        } catch let repoError as UserRepositoryError {
            self.errorMessage = repoError.localizedDescription
        } catch {
            self.errorMessage = "Unexpected error. Please try again."
        }
    }
    
    // MARK: - Sign out
    
    func signOut() {
        do {
            try authService.signOut()
            self.user = nil
        } catch let authError as AuthError {
            self.errorMessage = authError.localizedDescription
        } catch {
            self.errorMessage = "Unexpected error. Please try again."
        }
    }
}
