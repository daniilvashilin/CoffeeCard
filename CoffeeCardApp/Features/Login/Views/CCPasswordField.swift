import SwiftUI

struct CCPasswordField: View {
    var title: String
    @Binding var password: String
    
    @State private var showPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                if showPassword {
                    TextField("", text: $password)
                        .keyboardType(.emailAddress)
                } else {
                    SecureField("", text: $password)
                        .keyboardType(.emailAddress)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}
