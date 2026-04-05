//
//  LabelNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class LabelNodeMapper: BDUINodeMapper {
    let nodeType = "label"

    private struct Content: Codable {
        let text: String?
        let textStyle: String?
        let color: String?
        let alignment: String?
        let numberOfLines: Int?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let label = UILabel()
        label.text = config?.text ?? ""
        label.numberOfLines = config?.numberOfLines ?? 0

        let style = DSTokenResolver.textStyle(config?.textStyle ?? "body")
        label.apply(style)

        if let colorName = config?.color {
            label.textColor = DSTokenResolver.color(colorName)
        }

        if let alignment = config?.alignment {
            label.textAlignment = DSTokenResolver.textAlignment(alignment)
        }

        if let action = node.action {
            label.isUserInteractionEnabled = true
            actionHandler.attach(action: action, to: label)
        }

        return label
    }
}
