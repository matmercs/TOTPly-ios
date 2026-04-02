//
//  AddTOTPPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import Foundation

final class AddTOTPPresenterImpl: AddTOTPPresenter {
    private weak var view: AddTOTPView?
    private let repository: TOTPRepository
    private let router: AddTOTPRouter
    private let input: AddTOTPInput

    private var state: AddTOTPViewState = .initial

    init(repository: TOTPRepository, router: AddTOTPRouter, input: AddTOTPInput) {
        self.repository = repository
        self.router = router
        self.input = input
    }

    func setView(_ view: AddTOTPView) {
        self.view = view
    }

    func viewDidLoad() {
        if let name = input.prefilledName {
            state.name = name
        }
        if let issuer = input.prefilledIssuer {
            state.issuer = issuer
        }
        if let secret = input.prefilledSecret {
            state.secret = secret
        }
        render()
    }

    func didTapCancel() {
        router.popToDashboard()
    }

    func didTapScanQR() {
        router.openQRScanner { [weak self] scannedString in
            guard let self = self else { return }
            if let parsed = OTPAuthParser.parse(scannedString) {
                if let name = parsed.prefilledName {
                    self.state.name = name
                }
                if let issuer = parsed.prefilledIssuer {
                    self.state.issuer = issuer
                }
                if let secret = parsed.prefilledSecret {
                    self.state.secret = secret
                }
                self.render()
                self.view?.fillFields(name: self.state.name, issuer: self.state.issuer, secret: self.state.secret)
            }
        }
    }

    func didSave(name: String, issuer: String, secret: String) {
        state.name = name
        state.issuer = issuer
        state.secret = secret

        guard state.canSave else {
            state.errorMessage = "Заполните название и секретный ключ"
            render()
            return
        }

        state.loadingState = .loading
        state.errorMessage = nil
        render()

        let item = TOTPItem(
            id: UUID().uuidString,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            issuer: issuer.trimmingCharacters(in: .whitespacesAndNewlines),
            secret: secret.trimmingCharacters(in: .whitespacesAndNewlines),
            algorithm: .sha1,
            digits: 6,
            period: 30,
            createdAt: Date(),
            updatedAt: Date(),
            isDeleted: false,
            syncedAt: nil
        )

        Task { @MainActor in
            do {
                try await repository.saveItem(item)
                router.popToDashboard()
            } catch {
                state.loadingState = .initial
                state.errorMessage = error.localizedDescription
                render()
            }
        }
    }

    private func render() {
        view?.render(state)
    }
}
