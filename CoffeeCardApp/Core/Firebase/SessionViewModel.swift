import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol
    private var userListener: ListenerRegistration?
    
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
    
    deinit {
        userListener?.remove()
    }
    
    var isSignedIn: Bool {
        user != nil
    }
    
    // MARK: - Realtime listener
    
    private func startUserListener(userId: String) {
        // remove old listener
        userListener?.remove()
        
        userListener = Firestore.firestore()
            .collection("users")
            .document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self else { return }
                
                if let error = error {
                    print("User listener error:", error)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else { return }
                
                do {
                    var updatedUser = try snapshot.data(as: User.self)
                    if updatedUser.id == nil {
                        updatedUser.id = userId
                    }
                    
                    Task { @MainActor in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.user = updatedUser
                        }
                    }
                } catch {
                    print("User decoding error:", error)
                }
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
            startUserListener(userId: authUser.uid)
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
            startUserListener(userId: authUser.uid)
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
            startUserListener(userId: authUser.uid)
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
            userListener?.remove()
            user = nil
        } catch let authError as AuthError {
            self.errorMessage = authError.localizedDescription
        } catch {
            self.errorMessage = "Unexpected error. Please try again."
        }
    }
}
