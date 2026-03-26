//
//  DSShadows.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

extension DS {
    enum Shadow {
        struct Style {
            let color: UIColor
            let opacity: Float
            let offset: CGSize
            let radius: CGFloat
        }

        static let card = Style(
            color: .black,
            opacity: 0.08,
            offset: CGSize(width: 0, height: 2),
            radius: 8
        )
        
        // пока не используется
        static let elevated = Style(
            color: .black,
            opacity: 0.15,
            offset: CGSize(width: 0, height: 4),
            radius: 12
        )
        
        // пока не используется
        static let subtle = Style(
            color: .black,
            opacity: 0.04,
            offset: CGSize(width: 0, height: 1),
            radius: 4
        )
    }
}
