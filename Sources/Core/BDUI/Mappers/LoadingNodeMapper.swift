//
//  LoadingNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class LoadingNodeMapper: BDUINodeMapper {
    let nodeType = "loading"

    private struct Content: Codable {
        let message: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let container = UIView()

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = DS.Color.accent
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [spinner])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.s
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        if let message = config?.message {
            let label = UILabel()
            label.text = message
            label.apply(.callout)
            label.textAlignment = .center
            stack.addArrangedSubview(label)
        }

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: DS.Spacing.l),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -DS.Spacing.l),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])

        return container
    }
}
