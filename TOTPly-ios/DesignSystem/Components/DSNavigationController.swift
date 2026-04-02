//
//  DSNavigationController.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class DSNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        viewController.navigationItem.backButtonTitle = "Назад"
    }
}
