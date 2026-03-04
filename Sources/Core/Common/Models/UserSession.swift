//
//  UserSession.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.02.2026.
//

import Foundation

struct UserSession: Equatable, Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
    let expiresAt: Date
    
    var isExpired: Bool {
        return Date() >= expiresAt
    }
}
