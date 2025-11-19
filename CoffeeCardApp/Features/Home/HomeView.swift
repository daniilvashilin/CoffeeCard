//
//  HomeView.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 02/11/2025.
//

import SwiftUI

struct HomeView: View {
    @State var showQRCard: Bool = false
    var body: some View {
        VStack {
            HeaderView()
            PromoCarouselView()
            HStack {
                
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top)
    }
}

#Preview {
    HomeView()
}
