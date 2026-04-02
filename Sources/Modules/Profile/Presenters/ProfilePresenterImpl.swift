//
//  ProfilePresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

final class ProfilePresenterImpl: ProfilePresenter {
    private weak var view: ProfileView?
    private let authRepository: AuthRepository
    private let storage: StorageService
    private let router: ProfileRouter

    private var state: ProfileViewState = .initial

    init(authRepository: AuthRepository, storage: StorageService, router: ProfileRouter) {
        self.authRepository = authRepository
        self.storage = storage
        self.router = router
    }

    func setView(_ view: ProfileView) {
        self.view = view
    }

    func viewDidLoad() {
        state.userName = "Test User"
        state.userEmail = "user@test.com"
        state.sessions = makeMockSessions()
        loadSettings()
        state.loadingState = .loaded
        render()
    }

    func didTapEditName() {
        state.isEditingProfile = true
        state.editedName = state.userName
        render()
    }

    func didTapCancelEditName() {
        state.isEditingProfile = false
        render()
    }

    func didSaveName(_ name: String) {
        state.userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        state.isEditingProfile = false
        render()
    }

    func didTapChangePassword() {
        view?.showChangePasswordSent()
    }

    func didTapChangeEmail() {
        view?.showChangeEmailSent()
    }

    func didTapTerminateSession(id: String) {
        state.sessions.removeAll(where: { $0.id == id })
        render()
    }

    func didTapTerminateAllOtherSessions() {
        state.sessions = state.sessions.filter { $0.isCurrent }
        render()
    }

    func didToggleDarkMode(isOn: Bool) {
        state.isDarkMode = isOn
        saveSettings()
        render()
    }

    func didTapExportCodes() {
        view?.showExportUnavailable()
    }

    func didTapDeleteAccount() {
        view?.showDeleteAccountConfirmation { [weak self] in
            self?.didConfirmDeleteAccount()
        }
    }

    func didConfirmDeleteAccount() {
        try? authRepository.clearSession()
        router.navigateToLogin()
    }

    func didTapLogout() {
        try? authRepository.clearSession()
        router.navigateToLogin()
    }

    private func makeMockSessions() -> [SessionItem] {
        [
            SessionItem(
                id: "1",
                deviceName: "iPhone 15 Pro",
                lastActive: Date(),
                ipAddress: "192.168.1.10",
                isCurrent: true
            ),
            SessionItem(
                id: "2",
                deviceName: "MacBook Pro",
                lastActive: Date().addingTimeInterval(-3600),
                ipAddress: "192.168.1.20",
                isCurrent: false
            ),
            SessionItem(
                id: "3",
                deviceName: "Chrome (Windows)",
                lastActive: Date().addingTimeInterval(-86400),
                ipAddress: "85.143.22.15",
                isCurrent: false
            ),
            SessionItem(
                id: "4",
                deviceName: "Safari (iPad)",
                lastActive: Date().addingTimeInterval(-172800),
                ipAddress: "192.168.1.35",
                isCurrent: false
            ),
        ]
    }

    private func loadSettings() {
        if let settings: [String: Bool] = try? storage.load(key: StorageKey.settings.rawValue) {
            state.isDarkMode = settings["dark_mode"] ?? false
        }
    }

    private func saveSettings() {
        let settings: [String: Bool] = ["dark_mode": state.isDarkMode]
        try? storage.save(settings, key: StorageKey.settings.rawValue)
    }

    private func render() {
        view?.render(state)
    }
}
