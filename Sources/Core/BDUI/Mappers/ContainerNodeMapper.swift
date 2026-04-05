//
//  ContainerNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class ContainerNodeMapper: BDUINodeMapper {
    let nodeType = "container"

    private struct Content: Codable {
        let backgroundColor: String?
        let padding: String?
        let cornerRadius: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let container = UIView()
        container.backgroundColor = DSTokenResolver.color(config?.backgroundColor ?? "background")

        if let radius = config?.cornerRadius {
            container.layer.cornerRadius = DSTokenResolver.cornerRadius(radius)
            container.clipsToBounds = true
        }

        let padding = DSTokenResolver.spacing(config?.padding ?? "m")

        if let children = node.subviews, !children.isEmpty {
            let innerStack = UIStackView()
            innerStack.axis = .vertical
            innerStack.spacing = DS.Spacing.s
            innerStack.translatesAutoresizingMaskIntoConstraints = false

            for child in children {
                innerStack.addArrangedSubview(renderer.render(node: child))
            }

            container.addSubview(innerStack)
            NSLayoutConstraint.activate([
                innerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: padding),
                innerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding),
                innerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding),
                innerStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding),
            ])
        }

        if let action = node.action {
            actionHandler.attach(action: action, to: container)
        }

        return container
    }
}
