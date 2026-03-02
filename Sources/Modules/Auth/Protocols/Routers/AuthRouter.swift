//
//  AuthRouter.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol AuthRouter {
    func openRegistration()
    func openPasswordRecovery()
    func openEmailVerification(email: String, type: VerificationType)
    func openDashboard()
    func goBackToLogin()
}
