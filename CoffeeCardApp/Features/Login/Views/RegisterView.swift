import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var session: SessionViewModel

    @Binding var isTabBarHidden: Bool
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 20) {
            ImageTitle()
            CCTextField(title: "Name", text: $name, icon: "person")
            CCTextField(title: "Email", text: $email, icon: "envelope")
            CCPasswordField(title: "Password", password: $password)
            CCPasswordField(title: "Confirm Password", password: $confirmPassword)

            CCPrimaryButton(title: "Sign Up") {
                Task {
                    await session.signUp(email: email, password: password, name: name)
                }
            }
        }
        .padding()
        .onChange(of: session.isSignedIn, initial: false) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
