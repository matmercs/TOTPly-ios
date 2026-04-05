//
//  ButtonNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class ButtonNodeMapper: BDUINodeMapper {
    let nodeType = "button"

    private struct Content: Codable {
        let title: String?
        let style: String?
        let isEnabled: Bool?
        let isLoading: Bool?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let style = DSTokenResolver.buttonStyle(config?.style ?? "primary")
        let button = DSButton(style: style, title: config?.title ?? "")
        button.isEnabled = config?.isEnabled ?? true
        button.isLoading = config?.isLoading ?? false

        if let action = node.action {
            actionHandler.attach(action: action, to: button)
        }

        return button
    }
}
