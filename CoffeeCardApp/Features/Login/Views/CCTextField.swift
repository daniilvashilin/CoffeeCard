import SwiftUI

struct CCTextField: View {
    var title: String
    @Binding var text: String
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                }
                
                TextField("", text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}
