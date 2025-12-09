import SwiftUI

struct UserSettingsView: View {
    @State private var isLogoutPresented = false
    @EnvironmentObject private var sessionViewModel: SessionViewModel
    @Binding var isTabBarHidden: Bool
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(UserSettingsModel.allCases) { item in
                    if item == .logout {
                        Button {
                            isLogoutPresented = true
                        } label: {
                            Label(item.title, systemImage: item.systemImage)
                                .font(.appBody)
                        }
                        .foregroundStyle(.red)
                    } else {
                        NavigationLink {
                            item.destination
                        } label: {
                            Label(item.title, systemImage: item.systemImage)
                                .font(.appBody)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .font(.headline)
            .alert("Logout ?", isPresented: $isLogoutPresented) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    sessionViewModel.signOut()
                }
            }
            .scrollContentBackground(.hidden)
            .background(.backgroundApp)
            .disabled(!sessionViewModel.isSignedIn)
            .blur(radius: sessionViewModel.isSignedIn ? 0 : 1)
            .overlay {
                if !sessionViewModel.isSignedIn {
                    VStack(alignment: .center, spacing: 16) {
                        Image(systemName: "lock.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.primaryText)
                        
                        Text("You need to be signed in to Use Settings")
                            .font(.title2)
                            .foregroundStyle(.primaryText)
                            .multilineTextAlignment(.center)
                            .frame(width: 250)
                        
                        NavigationLink {
                            LoginView(isTabBarHidden: $isTabBarHidden)
                        } label: {
                            Text("Sign In")
                                .frame(width: 160, height: 46)
                                .background(.accentApp)
                                .foregroundStyle(.primaryText)
                                .cornerRadius(12)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                isTabBarHidden = true
                            }
                        })
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial.opacity(0.7))
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    isTabBarHidden = false
                }
            }
        }
    }
}
