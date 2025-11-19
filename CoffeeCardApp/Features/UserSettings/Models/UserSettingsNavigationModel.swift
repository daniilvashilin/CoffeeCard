//
//  UserSettingsNavigationModel.swift
//  KakaoExpressBrazilai
//
//  Created by Daniil Vaschilin on 18/11/2025.
//

import Foundation
import SwiftUI

enum UserSettingsModel: CaseIterable, Identifiable {
    case privacyPolicy
    case termsOfService
    case personalData
    case contactUs
    case feedback
    case logout

    var id: Self { self }

    var title: String {
        switch self {
        case .privacyPolicy:   return "Privacy Policy"
        case .termsOfService:  return "Terms of Service"
        case .personalData:    return "Personal Data"
        case .contactUs:       return "Contact Us"
        case .feedback:        return "Feedback"
        case .logout:          return "Logout"
        }
    }

    var systemImage: String {
        switch self {
        case .privacyPolicy:   return "lock"
        case .termsOfService:  return "doc.text"
        case .personalData:    return "person.crop.circle"
        case .contactUs:       return "envelope"
        case .feedback:        return "bubble.left"
        case .logout:          return "rectangle.portrait.and.arrow.right"
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .privacyPolicy:
            PrivacyPolicyView()
        case .termsOfService:
            TermsView()
        case .personalData:
            PersonalDataView()
        case .contactUs:
            ContactUsView()
        case .feedback:
            FeedbackView()
        case .logout:
            EmptyView() // тут можешь просто вызывать action вместо навигации
        }
    }
}
