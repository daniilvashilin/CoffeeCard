import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Binding var isTabBarHidden: Bool

    @StateObject private var viewModel = LoginViewModel()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            ImageTitle()
            
            CCTextField(
                title: "Email",
                text: $viewModel.email,
                icon: "envelope"
            )
            
            CCPasswordField(
                title: "Password",
                password: $viewModel.password
            )
            
            if let error = viewModel.validationError {
                Text(error.localizedDescription)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink {
                RegisterView(isTabBarHidden: $isTabBarHidden)
            } label: {
                Text("Not a member? Sign up")
            }

            CCPrimaryButton(title: viewModel.isLoading ? "Logging in..." : "Login") {
                Task {
                    await viewModel.login(using: sessionViewModel)
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .onChange(of: sessionViewModel.isSignedIn, initial: false) { oldValue, newValue in
            if oldValue != newValue, newValue {
                dismiss()
            }
        }
    }
}


