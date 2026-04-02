//
//  PasswordResetView.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

protocol PasswordResetView: AnyObject {
    func render(_ state: PasswordResetViewState)
}
