import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var validationError: ValidationError?
    @Published var isLoading: Bool = false

    @MainActor
    func login(using session: SessionViewModel) async {
        if let error = AuthValidator.validateLogin(
            email: email,
            password: password
        ) {
            validationError = error
            return
        }

        validationError = nil
        isLoading = true
        defer { isLoading = false }

        await session.signIn(email: email.trimmed,
                             password: password)
    }
}
