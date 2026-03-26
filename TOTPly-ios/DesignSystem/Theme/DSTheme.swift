//
//  DSTheme.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

protocol DSTheme {
    var background: UIColor { get }
    var surfaceCard: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var textCaption: UIColor { get }
    var accent: UIColor { get }
    var accentSecondary: UIColor { get }
    var error: UIColor { get }

    var separator: UIColor { get }
    var disabled: UIColor { get }
    var progressTrack: UIColor { get }
    var fieldBackground: UIColor { get }
    var fieldBorder: UIColor { get }

    var toastBackground: UIColor { get }
    var toastText: UIColor { get }

    var buttonPrimaryBackground: UIColor { get }
    var buttonPrimaryText: UIColor { get }
    var buttonSecondaryBackground: UIColor { get }
    var buttonSecondaryText: UIColor { get }
    var buttonDestructiveBackground: UIColor { get }
    var buttonDestructiveText: UIColor { get }
}
