//
//  EmptyNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class EmptyNodeMapper: BDUINodeMapper {
    let nodeType = "empty"

    private struct Content: Codable {
        let icon: String?
        let title: String?
        let subtitle: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let emptyView = DSEmptyView()
        let iconCodepoint = config?.icon.map { DSTokenResolver.icon($0) }
        emptyView.configure(
            icon: iconCodepoint,
            title: config?.title ?? "",
            subtitle: config?.subtitle
        )

        return emptyView
    }
}
