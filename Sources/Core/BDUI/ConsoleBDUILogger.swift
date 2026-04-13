//
//  ConsoleBDUILogger.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

final class ConsoleBDUILogger: BDUILogger {
    func report(event: String, params: [String: String]) {
        print("[BDUI Analytics] \(event): \(params)")
    }
}
