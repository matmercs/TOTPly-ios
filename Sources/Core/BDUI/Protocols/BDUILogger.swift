//
//  BDUILogger.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import Foundation

protocol BDUILogger {
    func report(event: String, params: [String: String])
}
