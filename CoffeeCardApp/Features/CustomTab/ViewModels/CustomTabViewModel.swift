//
//  CustomTabViewModel.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 26/10/2025.
//

import Foundation
import Observation

@Observable
final class CustomTabViewModel {
    var selected: CustomTabModel = .home
    let tabs: [CustomTabModel] = CustomTabModel.allCases
}
