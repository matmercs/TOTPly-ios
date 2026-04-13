//
//  BDUINode.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import Foundation

struct BDUINode: Codable, Equatable {
    let id: String
    let type: String
    let content: JSONValue?
    let subviews: [BDUINode]?
    let action: BDUIAction?
    let isVisible: Bool?

    init(
        id: String,
        type: String,
        content: JSONValue? = nil,
        subviews: [BDUINode]? = nil,
        action: BDUIAction? = nil,
        isVisible: Bool? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.subviews = subviews
        self.action = action
        self.isVisible = isVisible
    }
}
