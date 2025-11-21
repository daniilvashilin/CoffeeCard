//
//  RootView.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 26/10/2025.
//

import SwiftUI

struct RootView: View {
    @State private var selection: CustomTabModel = .home
    private let tabs = CustomTabModel.allCases
    @StateObject private var promoViewModel =
    PromoViewModel(repository: FirestorePromoRepository())
    var body: some View {
        ZStack {
            
            Group {
                switch selection {
                case .home:
                    HomeView(promoViewModel: promoViewModel)
                case .Menu:
                    MenuView()
                case .profile:
                    UserSettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundApp)
            .ignoresSafeArea(edges: .bottom)
            VStack { Spacer() }
                .safeAreaInset(edge: .bottom) {
                    GeometryReader { proxy in
                        let w = proxy.size.width - 24   // side padding
                        CustomTabView(
                            width: w,
                            height: 75,
                            cornerRadius: 40,
                            selection: $selection,
                            tabs: tabs
                        )
                        .frame(maxWidth: .infinity)     // center it
                    }
                    .frame(height: 80) // space to measure width + breathing room
                }
        }
    }
}

#Preview {
    RootView()
}
