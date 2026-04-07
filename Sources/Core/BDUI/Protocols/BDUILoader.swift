//
//  BDUILoader.swift
//  TOTPly-ios
//
//  Created by Matthew on 07.04.2026.
//

import Foundation

protocol BDUILoader {
    func loadFromEndpoint(_ endpoint: String) async throws -> BDUINode
    func loadFromBundle(named fileName: String) throws -> BDUINode
}
