//
//  UIView+DS.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

extension UIView {
    func applyShadow(_ style: DS.Shadow.Style) {
        layer.shadowColor = style.color.cgColor
        layer.shadowOpacity = style.opacity
        layer.shadowOffset = style.offset
        layer.shadowRadius = style.radius
        layer.masksToBounds = false
    }

    func applyCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
