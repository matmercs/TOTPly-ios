//
//  BDUINodeRendererImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class BDUINodeRendererImpl: BDUINodeRenderer {
    private let registry: BDUIMapperRegistry
    private let actionHandler: BDUIActionHandler

    init(registry: BDUIMapperRegistry, actionHandler: BDUIActionHandler) {
        self.registry = registry
        self.actionHandler = actionHandler
    }

    func render(node: BDUINode) -> UIView {
        guard node.isVisible != false else {
            let empty = UIView()
            empty.isHidden = true
            empty.translatesAutoresizingMaskIntoConstraints = false
            return empty
        }

        let mapper = registry.mapper(for: node.type)
        let view = mapper.makeView(from: node, renderer: self, actionHandler: actionHandler)
        view.accessibilityIdentifier = node.id
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func renderScreen(from json: Data) throws -> UIView {
        let node = try JSONDecoder().decode(BDUINode.self, from: json)
        return render(node: node)
    }
}
