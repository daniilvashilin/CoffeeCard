import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var validationError: ValidationError?
    @Published var isLoading: Bool = false

    @MainActor
    func register(using session: SessionViewModel) async {
        if let error = AuthValidator.validateRegister(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        ) {
            validationError = error
            return
        }

        validationError = nil
        isLoading = true
        defer { isLoading = false }

        await session.signUp(email: email.trimmed,
                             password: password,
                             name: name.trimmed)
    }
}
