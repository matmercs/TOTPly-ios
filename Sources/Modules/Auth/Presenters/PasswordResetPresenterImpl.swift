//
//  PasswordResetPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

final class PasswordResetPresenterImpl: PasswordResetPresenter {
    private weak var view: PasswordResetView?
    private let router: AuthRouter
    private let authRepository: AuthRepository

    private var state: PasswordResetViewState = .initial

    init(router: AuthRouter, authRepository: AuthRepository) {
        self.router = router
        self.authRepository = authRepository
    }

    func setView(_ view: PasswordResetView) {
        self.view = view
    }

    func viewDidLoad() {
        state = .initial
        render()
    }

    func didTapSendResetCode(email: String) {
        state.email = email
        state.errorMessage = nil

        guard state.canSubmitEmail else {
            state.errorMessage = "Введите email"
            render()
            return
        }

        state.loadingState = .loading
        render()

        Task { @MainActor in
            do {
                try await authRepository.requestPasswordReset(email: email)
                state.loadingState = .initial
                state.step = .enterCode
                state.errorMessage = nil
                render()
            } catch {
                state.loadingState = .initial
                state.errorMessage = "Не удалось отправить код"
                render()
            }
        }
    }

    func didEnterCode(_ code: String) {
        state.code = code
        state.errorMessage = nil
        render()
    }

    func didTapVerifyCode() {
        guard state.isCodeComplete else { return }
        state.step = .newPassword
        state.errorMessage = nil
        render()
    }

    func didTapResetPassword(newPassword: String, confirmPassword: String) {
        state.newPassword = newPassword
        state.confirmPassword = confirmPassword
        state.errorMessage = nil

        if state.passwordMismatch {
            state.errorMessage = "Пароли не совпадают"
            render()
            return
        }

        guard state.canSubmitReset else {
            state.errorMessage = "Заполните все поля"
            render()
            return
        }

        state.loadingState = .loading
        render()

        Task { @MainActor in
            do {
                try await authRepository.verifyPasswordReset(
                    email: state.email,
                    code: state.code,
                    newPassword: newPassword
                )
                router.goBackToLogin()
            } catch {
                state.loadingState = .initial
                state.errorMessage = "Не удалось сбросить пароль"
                render()
            }
        }
    }

    func didTapBack() {
        switch state.step {
        case .newPassword:
            state.step = .enterCode
            state.newPassword = ""
            state.confirmPassword = ""
            state.errorMessage = nil
            render()
        case .enterCode:
            state.step = .requestReset
            state.code = ""
            state.errorMessage = nil
            render()
        case .requestReset:
            router.goBackToLogin()
        }
    }

    private func render() {
        view?.render(state)
    }
}
