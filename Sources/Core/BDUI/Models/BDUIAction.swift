//
//  BDUIAction.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import Foundation

struct BDUIAction: Codable, Equatable {
    let type: ActionType
    let payload: JSONValue?

    enum ActionType: String, Codable {
        case print
        case open
        case alert
        case reload
        case http
    }

    init(type: ActionType, payload: JSONValue? = nil) {
        self.type = type
        self.payload = payload
    }
}
