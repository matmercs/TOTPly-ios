//
//  SessionItem.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

struct SessionItem: Equatable, Identifiable {
    let id: String
    let deviceName: String
    let lastActive: Date
    let ipAddress: String
    let isCurrent: Bool
}
