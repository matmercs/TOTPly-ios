//
//  CardNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class CardNodeMapper: BDUINodeMapper {
    let nodeType = "card"

    private struct Content: Codable {
        let padding: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)
        let card = DSCard()

        if let children = node.subviews, !children.isEmpty {
            let innerStack = UIStackView()
            innerStack.axis = .vertical
            innerStack.spacing = DS.Spacing.s
            innerStack.translatesAutoresizingMaskIntoConstraints = false

            for child in children {
                innerStack.addArrangedSubview(renderer.render(node: child))
            }

            let padding = DSTokenResolver.spacing(config?.padding ?? "m")
            card.cardContent.addSubview(innerStack)
            NSLayoutConstraint.activate([
                innerStack.topAnchor.constraint(equalTo: card.cardContent.topAnchor, constant: padding),
                innerStack.leadingAnchor.constraint(equalTo: card.cardContent.leadingAnchor, constant: padding),
                innerStack.trailingAnchor.constraint(equalTo: card.cardContent.trailingAnchor, constant: -padding),
                innerStack.bottomAnchor.constraint(equalTo: card.cardContent.bottomAnchor, constant: -padding),
            ])
        }

        if let action = node.action {
            actionHandler.attach(action: action, to: card)
        }

        return card
    }
}
