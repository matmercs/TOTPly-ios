//
//  DividerNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class DividerNodeMapper: BDUINodeMapper {
    let nodeType = "divider"

    private struct Content: Codable {
        let color: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let divider = UIView()
        divider.backgroundColor = DSTokenResolver.color(config?.color ?? "separator")
        divider.heightAnchor.constraint(equalToConstant: DS.Size.Separator.height).isActive = true
        divider.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return divider
    }
}
