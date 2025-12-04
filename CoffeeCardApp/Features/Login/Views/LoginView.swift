import SwiftUI

struct LoginView: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    @Binding var isTabBarHidden: Bool

    @State private var email = ""
    @State private var password = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            ImageTitle()
            CCTextField(title: "Email", text: $email, icon: "envelope")
            CCPasswordField(title: "Password", password: $password)
            NavigationLink {
                RegisterView()
            } label: {
                Text("Not a member? Sign up")
            }

            CCPrimaryButton(title: "Login") {
                Task {
                    await sessionViewModel.signIn(email: email, password: password)
                }
            }
        }
        .padding()
        .onAppear {
            isTabBarHidden = true
        }
        .onDisappear {
            isTabBarHidden = false
        }
        .onChange(of: sessionViewModel.isSignedIn, initial: false) { oldValue, newValue in
            if oldValue != newValue, newValue {
                dismiss()
            }
        }
    }
}

struct ImageTitle: View {
    var body: some View {
        Image(.logoLaunch)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 150)
    }
}


