//
//  BDUINodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

protocol BDUINodeMapper {
    var nodeType: String { get }
    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView
}
