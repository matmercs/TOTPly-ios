//
//  FallbackNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class FallbackNodeMapper: BDUINodeMapper {
    let nodeType = "fallback"

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let container = UIView()

        let label = UILabel()
        label.text = "Unknown: \(node.type)"
        label.apply(.caption)
        label.textColor = DS.Color.textCaption
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        container.backgroundColor = DS.Color.error.withAlphaComponent(0.1)
        container.layer.cornerRadius = DS.CornerRadius.small
        container.layer.borderWidth = 1
        container.layer.borderColor = DS.Color.error.withAlphaComponent(0.3).cgColor

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: DS.Spacing.xs),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: DS.Spacing.s),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -DS.Spacing.s),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -DS.Spacing.xs),
        ])

        return container
    }
}
