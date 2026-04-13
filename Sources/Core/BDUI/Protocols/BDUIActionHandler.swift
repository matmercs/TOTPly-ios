//
//  BDUIActionHandler.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

protocol BDUIActionHandler: AnyObject {
    func attach(action: BDUIAction, to view: UIView)
    func execute(action: BDUIAction)
}
