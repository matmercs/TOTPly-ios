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

        let hasHeight = config?.height != nil
        let hasWidth = config?.width != nil

        if let height = config?.height {
            spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let width = config?.width {
            spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if !hasHeight && !hasWidth {
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
            spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            spacer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }

        return spacer
    }
}
