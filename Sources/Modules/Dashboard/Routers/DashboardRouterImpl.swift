//
//  DashboardRouterImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class DashboardRouterImpl: DashboardRouter {
    weak var navigationController: UINavigationController?

    func openCodeDetail(itemId: String) {
        let detailVC = CodeDetailStubViewController(itemId: itemId)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func openAddTOTP() {
        print("[DashboardRouter] openAddTOTP")
    }

    func openSettings() {
        print("[DashboardRouter] openSettings")
    }

    func openProfile() {
        print("[DashboardRouter] openProfile")
    }
}
