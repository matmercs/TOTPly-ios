//
//  AddTOTPRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class AddTOTPRouterImpl: AddTOTPRouter {
    weak var navigationController: UINavigationController?

    func popToDashboard() {
        navigationController?.popViewController(animated: true)
    }

    func openQRScanner(completion: @escaping (String) -> Void) {
        let scanner = QRScannerViewController(completion: completion)
        let nav = DSNavigationController(rootViewController: scanner)
        nav.modalPresentationStyle = .fullScreen
        navigationController?.present(nav, animated: true)
    }
}
