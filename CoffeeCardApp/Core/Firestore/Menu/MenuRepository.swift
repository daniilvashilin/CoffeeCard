//
//  MenuRepository.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 18/11/2025.
//

import Foundation

protocol MenuRepository {
    func fetchMenu() async throws -> [MenuItemModel]
}
