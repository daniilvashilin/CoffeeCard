//
//  UserSettingsView.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 02/11/2025.
//

import SwiftUI

struct UserSettingsView: View {
    @State private var isLogoutPresented = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(UserSettingsModel.allCases) { item in
                    if item == .logout {
                        Button {
                            // logoutAction()
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
                    // Logount mehod 
                }
            }
        }
    }
}

#Preview {
    UserSettingsView()
}
