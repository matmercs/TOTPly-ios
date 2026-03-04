//
//  AppCoordinator.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let storage = KeychainStorageService()
        let authRepository = LocalAuthRepository(storage: storage)
        let authRouter = AuthRouterImpl(window: window, authRepository: authRepository)
        authRouter.start()
    }
}
