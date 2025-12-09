import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var session: SessionViewModel
    @Binding var isTabBarHidden: Bool

    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            ImageTitle()

            CCTextField(title: "Name", text: $viewModel.name, icon: "person")
            CCTextField(title: "Email", text: $viewModel.email, icon: "envelope")
            CCPasswordField(title: "Password", password: $viewModel.password)
            CCPasswordField(title: "Confirm Password", password: $viewModel.confirmPassword)

            if let error = viewModel.validationError {
                Text(error.localizedDescription)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            CCPrimaryButton(title: viewModel.isLoading ? "Signing up..." : "Sign Up") {
                Task {
                    await viewModel.register(using: session)
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .onAppear { isTabBarHidden = true }
        .onDisappear { isTabBarHidden = false }
        .onChange(of: session.isSignedIn, initial: false) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
