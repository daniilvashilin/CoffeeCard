//
//  CoinsInfoView.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 15/11/2025.
//

import SwiftUI

struct CoinsInfoView: View {
    var body: some View {
        VStack {
            HStack {
                Text("The amount of:")
                    .foregroundStyle(.primaryText)
                Image(.coin)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}

#Preview {
    CoinsInfoView()
}
