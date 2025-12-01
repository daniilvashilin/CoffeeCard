import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ImageTitle()
            CCTextField(title: "Email", text: $email, icon: "envelope")
            CCPasswordField(title: "Password", password: $password)
            
            CCPrimaryButton(title: "Login") {
                Task {
                    await session.signIn(email: email, password: password)
                }
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

struct ImageTitle: View {
    var body: some View {
        Image(.logoLaunch)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 150)
    }
}


