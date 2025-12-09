import Foundation

// MARK: - String helpers

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValidEmail: Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return range(of: pattern, options: .regularExpression) != nil
    }

    var isStrongPassword: Bool {
        return count >= 8
    }
}

// MARK: - High-level validation

enum AuthValidator {
    static func validateRegister(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) -> ValidationError? {

        let name = name.trimmed
        let email = email.trimmed

        if name.isEmpty {
            return .emptyName
        }
        if email.isEmpty {
            return .emptyEmail
        }
        if !email.isValidEmail {
            return .invalidEmail
        }
        if password.isEmpty {
            return .emptyPassword
        }
        if !password.isStrongPassword {
            return .weakPassword
        }
        if password != confirmPassword {
            return .passwordsDontMatch
        }

        return nil
    }

    static func validateLogin(email: String, password: String) -> ValidationError? {
        let email = email.trimmed

        if email.isEmpty {
            return .emptyEmail
        }
        if !email.isValidEmail {
            return .invalidEmail
        }
        if password.isEmpty {
            return .emptyPassword
        }

        return nil
    }
}
