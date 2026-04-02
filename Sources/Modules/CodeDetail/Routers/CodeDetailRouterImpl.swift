//
//  CodeDetailRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class CodeDetailRouterImpl: CodeDetailRouter {
    weak var navigationController: UINavigationController?

    func popToDashboard() {
        navigationController?.popViewController(animated: true)
    }
}
