//
//  RegistrationPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import Foundation

final class RegistrationPresenterImpl: RegistrationPresenter {
    private weak var view: RegistrationView?
    private let router: AuthRouter
    private let authRepository: AuthRepository

    private var state: RegistrationViewState = .initial {
        didSet { view?.render(state) }
    }

    init(router: AuthRouter, authRepository: AuthRepository) {
        self.router = router
        self.authRepository = authRepository
    }

    func setView(_ view: RegistrationView) {
        self.view = view
    }

    func viewDidLoad() {
        state = .initial
        view?.render(state)
    }

    func didTapRegister(email: String, password: String, displayName: String?) {
        state.loadingState = .loading
        state.validationErrors = .init()
        view?.render(state)

        Task { @MainActor in
            do {
                let result = try await authRepository.register(email: email, password: password, displayName: displayName)
                switch result {
                case .session:
                    router.openDashboard()
                case .requiresEmailVerification(let email):
                    state.loadingState = .initial
                    view?.render(state)
                    router.openEmailVerification(email: email, type: .registration)
                }
            } catch {
                state.loadingState = .error(AppError.authError(error as? AuthError ?? .invalidCredentials))
                view?.render(state)
            }
        }
    }

    func didTapGoToLogin() {
        router.goBackToLogin()
    }

    func didChangeEmail(_ email: String) {
        state.email = email
        state.isRegisterButtonEnabled = !email.isEmpty && !state.password.isEmpty && !state.displayName.isEmpty
        state.validationErrors.emailError = nil
        view?.render(state)
    }

    func didChangePassword(_ password: String) {
        state.password = password
        state.isRegisterButtonEnabled = !state.email.isEmpty && !password.isEmpty && !state.displayName.isEmpty
        state.validationErrors.passwordError = nil
        view?.render(state)
    }

    func didChangeDisplayName(_ displayName: String) {
        state.displayName = displayName
        state.isRegisterButtonEnabled = !state.email.isEmpty && !state.password.isEmpty && !displayName.isEmpty
        state.validationErrors.displayNameError = nil
        view?.render(state)
    }
}
