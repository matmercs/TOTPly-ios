//
//  ProfilePresenter.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

protocol ProfilePresenter {
    func viewDidLoad()
    func didTapEditName()
    func didTapCancelEditName()
    func didSaveName(_ name: String)
    func didTapChangePassword()
    func didTapChangeEmail()
    func didTapTerminateSession(id: String)
    func didTapTerminateAllOtherSessions()
    func didToggleDarkMode(isOn: Bool)
    func didTapExportCodes()
    func didTapDeleteAccount()
    func didConfirmDeleteAccount()
    func didTapLogout()
}
