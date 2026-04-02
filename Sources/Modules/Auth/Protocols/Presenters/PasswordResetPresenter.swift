//
//  PasswordResetPresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

protocol PasswordResetPresenter {
    func viewDidLoad()
    func didTapSendResetCode(email: String)
    func didEnterCode(_ code: String)
    func didTapVerifyCode()
    func didTapResetPassword(newPassword: String, confirmPassword: String)
    func didTapBack()
}
