//
//  ProfileView.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

protocol ProfileView: AnyObject {
    func render(_ state: ProfileViewState)
    func showChangePasswordSent()
    func showChangeEmailSent()
    func showExportUnavailable()
    func showDeleteAccountConfirmation(onConfirm: @escaping () -> Void)
}
