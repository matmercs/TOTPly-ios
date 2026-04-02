//
//  VerificationPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

final class VerificationPresenterImpl: VerificationPresenter {
    private weak var view: VerificationView?
    private let router: AuthRouter
    private let authRepository: AuthRepository
    private let email: String
    private let verificationType: VerificationType

    private var state: VerificationViewState
    private var cooldownTimer: Timer?

    init(router: AuthRouter, authRepository: AuthRepository, email: String, verificationType: VerificationType) {
        self.router = router
        self.authRepository = authRepository
        self.email = email
        self.verificationType = verificationType
        self.state = .initial(email: email, type: verificationType)
    }

    func setView(_ view: VerificationView) {
        self.view = view
    }

    func viewDidLoad() {
        startCooldownTimer()
        render()
    }

    func didEnterCode(_ code: String) {
        state.code = code
        state.validationError = nil
        render()
    }

    func didTapVerify() {
        guard state.isCodeComplete else { return }

        state.loadingState = .loading
        render()

        Task { @MainActor in
            do {
                let response = try await authRepository.verifyEmail(code: state.code)
                let session = UserSession(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    userId: response.userId,
                    expiresAt: Date().addingTimeInterval(TimeInterval(response.expiresIn))
                )
                try authRepository.saveSession(session)
                router.openDashboard()
            } catch {
                state.loadingState = .error(.authError(.invalidCredentials))
                render()
            }
        }
    }

    func didTapResendCode() {
        guard state.canResendCode else { return }

        Task { @MainActor in
            do {
                let response = try await authRepository.resendVerificationCode(email: email)
                state.resendCooldownSeconds = response.cooldownSeconds
                state.canResendCode = false
                startCooldownTimer()
                render()
            } catch {
                state.validationError = "Не удалось отправить код"
                render()
            }
        }
    }

    func didTapBack() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
    }

    deinit {
        cooldownTimer?.invalidate()
    }

    private func startCooldownTimer() {
        cooldownTimer?.invalidate()
        state.canResendCode = false

        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.state.resendCooldownSeconds -= 1
            if self.state.resendCooldownSeconds <= 0 {
                self.state.canResendCode = true
                self.cooldownTimer?.invalidate()
                self.cooldownTimer = nil
            }
            self.render()
        }
        RunLoop.main.add(timer, forMode: .common)
        cooldownTimer = timer
    }

    private func render() {
        view?.render(state)
    }
}
