//
//  IconNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class IconNodeMapper: BDUINodeMapper {
    let nodeType = "icon"

    private struct Content: Codable {
        let icon: String?
        let size: String?
        let tint: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        let iconSize = DSTokenResolver.iconSize(config?.size ?? "medium")
        let tint = DSTokenResolver.color(config?.tint ?? "textPrimary")
        let codepoint = DSTokenResolver.icon(config?.icon ?? "error")

        imageView.image = DS.Icon.image(codepoint, size: iconSize, tint: tint)

        let sizeValue = iconSize.rawValue
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: sizeValue),
            imageView.heightAnchor.constraint(equalToConstant: sizeValue),
        ])

        if let action = node.action {
            imageView.isUserInteractionEnabled = true
            actionHandler.attach(action: action, to: imageView)
        }

        return imageView
    }
}
