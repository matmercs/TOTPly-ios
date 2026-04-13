//
//  ScrollNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class ScrollNodeMapper: BDUINodeMapper {
    let nodeType = "scroll"

    private struct Content: Codable {
        let axis: String?
        let padding: String?
        let spacing: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        let isVertical = (config?.axis ?? "vertical") == "vertical"
        let padding = DSTokenResolver.spacing(config?.padding ?? "l")
        let spacing = DSTokenResolver.spacing(config?.spacing ?? "m")

        let contentStack = UIStackView()
        contentStack.axis = isVertical ? .vertical : .horizontal
        contentStack.spacing = spacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: padding),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: padding),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -padding),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -padding),
        ])

        if isVertical {
            contentStack.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -2 * padding
            ).isActive = true
        } else {
            contentStack.heightAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.heightAnchor,
                constant: -2 * padding
            ).isActive = true
        }

        for child in node.subviews ?? [] {
            contentStack.addArrangedSubview(renderer.render(node: child))
        }

        return scrollView
    }
}
