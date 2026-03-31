//
//  CodeDetailPresenterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import Foundation

final class CodeDetailPresenterImpl: CodeDetailPresenter {
    private weak var view: CodeDetailView?
    private let repository: TOTPRepository
    private let generator: TOTPGenerator
    private let router: CodeDetailRouter
    private let input: CodeDetailInput

    private var state: CodeDetailViewState = .initial
    private var codeTimer: Timer?

    init(repository: TOTPRepository, generator: TOTPGenerator, router: CodeDetailRouter, input: CodeDetailInput) {
        self.repository = repository
        self.generator = generator
        self.router = router
        self.input = input
    }

    func setView(_ view: CodeDetailView) {
        self.view = view
    }

    func viewDidLoad() {
        state.loadingState = .loading
        render()

        Task { @MainActor in
            do {
                let items = try await repository.fetchLocalItems()
                guard let item = items.first(where: { $0.id == input.itemId }) else {
                    state.loadingState = .error(.unknown("Запись не найдена"))
                    render()
                    return
                }
                state.item = item
                regenerateCode()
                state.loadingState = .loaded
                render()
            } catch {
                state.loadingState = .error(.unknown(error.localizedDescription))
                render()
            }
        }
    }

    func viewWillAppear() {
        startTimer()
    }

    func viewWillDisappear() {
        codeTimer?.invalidate()
        codeTimer = nil
    }

    func didTapCopyCode() {
        view?.copyCodeToClipboard(state.currentCode)
    }

    func didTapEdit() {
        state.isEditing = true
        render()
    }

    func didTapCancelEdit() {
        state.isEditing = false
        render()
    }

    func didSave(name: String, issuer: String) {
        guard let item = state.item else { return }
        let updated = item.withUpdated(name: name, issuer: issuer)

        Task { @MainActor in
            do {
                try await repository.saveItem(updated)
                state.item = updated
                state.isEditing = false
                render()
            } catch {
                state.loadingState = .error(.unknown(error.localizedDescription))
                render()
            }
        }
    }

    func didTapDelete() {
        view?.showDeleteConfirmation { [weak self] in
            self?.didConfirmDelete()
        }
    }

    func didConfirmDelete() {
        guard let item = state.item else { return }

        Task { @MainActor in
            do {
                try await repository.deleteItem(id: item.id)
                router.popToDashboard()
            } catch {
                state.loadingState = .error(.unknown(error.localizedDescription))
                render()
            }
        }
    }

    func didTapShare() {
        guard let item = state.item else { return }
        let text = "\(item.name): \(state.currentCode)"
        view?.showShareSheet(text: text)
    }

    func timerDidTick() {
        regenerateCode()
        render()
    }

    private func startTimer() {
        codeTimer?.invalidate()
        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timerDidTick()
        }
        RunLoop.main.add(timer, forMode: .common)
        codeTimer = timer
    }

    private func regenerateCode() {
        guard let item = state.item else { return }
        if let code = generator.generateCode(
            secret: item.secret,
            algorithm: item.algorithm,
            digits: item.digits,
            period: item.period
        ) {
            state.currentCode = code
        }
        state.timeRemaining = generator.getSecondsRemaining(period: item.period)
        state.progressPercentage = Double(state.timeRemaining) / Double(item.period)
    }

    private func render() {
        view?.render(state)
    }
}
