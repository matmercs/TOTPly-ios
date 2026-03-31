//
//  OTPAuthParser.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import Foundation

enum OTPAuthParser {

    static func parse(_ uri: String) -> AddTOTPInput? {
        guard let components = URLComponents(string: uri),
              components.scheme == "otpauth",
              components.host == "totp" else {
            return nil
        }

        let queryItems = components.queryItems ?? []
        let secret = queryItems.first(where: { $0.name == "secret" })?.value
        let issuer = queryItems.first(where: { $0.name == "issuer" })?.value

        var name: String?
        let path = components.path.hasPrefix("/") ? String(components.path.dropFirst()) : components.path
        if path.contains(":") {
            name = String(path.split(separator: ":").last ?? "").trimmingCharacters(in: .whitespaces)
        } else if !path.isEmpty {
            name = path
        }

        guard secret != nil else { return nil }

        return AddTOTPInput(
            prefilledSecret: secret,
            prefilledName: name,
            prefilledIssuer: issuer
        )
    }
}
