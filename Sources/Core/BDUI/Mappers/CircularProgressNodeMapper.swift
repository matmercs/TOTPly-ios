//
//  CircularProgressNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class CircularProgressNodeMapper: BDUINodeMapper {
    let nodeType = "circularProgress"

    private struct Content: Codable {
        let progress: Double?
        let timeText: String?
        let isExpiring: Bool?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let progressView = DSCircularProgress()
        progressView.configure(
            progress: config?.progress ?? 1.0,
            timeText: config?.timeText ?? "",
            isExpiring: config?.isExpiring ?? false
        )

        let size = DS.Size.CircularTimer.size
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: size),
            progressView.heightAnchor.constraint(equalToConstant: size),
        ])

        return progressView
    }
}
