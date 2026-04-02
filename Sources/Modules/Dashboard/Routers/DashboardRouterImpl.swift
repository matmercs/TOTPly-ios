//
//  DashboardRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class DashboardRouterImpl: DashboardRouter {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?

    private let repository: TOTPRepository
    private let generator: TOTPGenerator
    private let authRepository: AuthRepository
    private let storage: StorageService

    init(
        repository: TOTPRepository,
        generator: TOTPGenerator,
        authRepository: AuthRepository,
        storage: StorageService
    ) {
        self.repository = repository
        self.generator = generator
        self.authRepository = authRepository
        self.storage = storage
    }

    func openCodeDetail(itemId: String) {
        let router = CodeDetailRouterImpl()
        let input = CodeDetailInput(itemId: itemId, preloadedItem: nil)
        let presenter = CodeDetailPresenterImpl(
            repository: repository,
            generator: generator,
            router: router,
            input: input
        )
        let vc = CodeDetailViewController(presenter: presenter)
        presenter.setView(vc)
        router.navigationController = navigationController
        navigationController?.pushViewController(vc, animated: true)
    }

    func openAddTOTP() {
        let router = AddTOTPRouterImpl()
        let presenter = AddTOTPPresenterImpl(
            repository: repository,
            router: router,
            input: .empty
        )
        let vc = AddTOTPViewController(presenter: presenter)
        presenter.setView(vc)
        router.navigationController = navigationController
        navigationController?.pushViewController(vc, animated: true)
    }

    func openSettings() {
        openProfile()
    }

    func openProfile() {
        let router = ProfileRouterImpl()
        router.navigationController = navigationController
        router.window = window
        let presenter = ProfilePresenterImpl(
            authRepository: authRepository,
            storage: storage,
            router: router
        )
        let vc = ProfileViewController(presenter: presenter)
        presenter.setView(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
