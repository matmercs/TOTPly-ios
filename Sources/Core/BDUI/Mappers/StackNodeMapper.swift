//
//  StackNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class StackNodeMapper: BDUINodeMapper {
    let nodeType: String
    private let axis: NSLayoutConstraint.Axis

    init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        self.nodeType = axis == .vertical ? "vStack" : "hStack"
    }

    private struct Content: Codable {
        let spacing: String?
        let alignment: String?
        let distribution: String?
        let padding: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = DSTokenResolver.spacing(config?.spacing ?? "m")

        if let alignment = config?.alignment {
            stack.alignment = DSTokenResolver.stackAlignment(alignment)
        }

        if let distribution = config?.distribution {
            stack.distribution = DSTokenResolver.stackDistribution(distribution)
        }

        if let padding = config?.padding {
            stack.isLayoutMarginsRelativeArrangement = true
            let inset = DSTokenResolver.spacing(padding)
            stack.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }

        for child in node.subviews ?? [] {
            let childView = renderer.render(node: child)
            stack.addArrangedSubview(childView)
        }

        if let action = node.action {
            actionHandler.attach(action: action, to: stack)
        }

        return stack
    }
}
