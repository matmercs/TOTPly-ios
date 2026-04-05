//
//  SpacerNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class SpacerNodeMapper: BDUINodeMapper {
    let nodeType = "spacer"

    private struct Content: Codable {
        let height: CGFloat?
        let width: CGFloat?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let spacer = UIView()
        spacer.backgroundColor = .clear

        if let height = config?.height {
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            spacer.heightAnchor.constraint(equalToConstant: DS.Spacing.l).isActive = true
        }

        if let width = config?.width {
            spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        return spacer
    }
}
