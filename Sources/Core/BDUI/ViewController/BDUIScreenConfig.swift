//
//  BDUIScreenConfig.swift
//  TOTPly-ios
//
//  Created by Matthew on 07.04.2026.
//

import Foundation

struct BDUIScreenConfig {
    let endpoint: String
    let title: String?
    let fallbackBundleName: String?

    init(endpoint: String, title: String? = nil, fallbackBundleName: String? = nil) {
        self.endpoint = endpoint
        self.title = title
        self.fallbackBundleName = fallbackBundleName
    }
}
