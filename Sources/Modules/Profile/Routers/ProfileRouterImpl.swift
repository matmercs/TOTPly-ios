//
//  ProfileRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import UIKit

final class ProfileRouterImpl: ProfileRouter {
    weak var navigationController: UINavigationController?
    weak var window: UIWindow?

    func navigateToLogin() {
        let storage = KeychainStorageService()
        let authRepository = LocalAuthRepository(storage: storage)
        let authRouter = AuthRouterImpl(window: window, authRepository: authRepository)
        authRouter.start()
    }
}
