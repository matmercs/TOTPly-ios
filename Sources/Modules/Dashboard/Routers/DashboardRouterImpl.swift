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
    
    // Для демонстрации:
    // "native"    нативный ProfileViewController
    // "bdui"      BDUI обычный пользователь
    // "corporate" BDUI корпоративный (организация, SSO, роли, администрирование)
    // "security"  BDUI подозрительная сессия (ограничения, верификация, geo-ip)
    var profileMode = "security"

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
    
    func openProfile() {
        switch profileMode {
        case "bdui":       openBDUIProfile(jsonName: "bdui_profile")
        case "corporate":  openBDUIProfile(jsonName: "bdui_profile_corporate")
        case "security":   openBDUIProfile(jsonName: "bdui_profile_security")
        default:           openNativeProfile()
        }
    }

    private func openNativeProfile() {
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

    private func openBDUIProfile(jsonName: String) {
        let vc = BDUIViewController()
        vc.title = "Профиль"
        vc.loadJSONFromBundle(named: jsonName)
        vc.onNavigate = { [weak self] route in
            switch route {
            case "welcome":
                try? self?.authRepository.clearSession()
                let authRouter = AuthRouterImpl(
                    window: self?.window,
                    authRepository: self?.authRepository ?? LocalAuthRepository(storage: KeychainStorageService())
                )
                authRouter.start()
            default:
                break
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
