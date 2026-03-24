//
//  DSColors.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

enum DS {

    enum Palette {

        // Light mode
        static let sageMist = UIColor(red: 0.96, green: 0.97, blue: 0.96, alpha: 1)      // #F5F7F4
        static let white = UIColor.white                                                 // #FFFFFF
        static let deepForest = UIColor(red: 0.11, green: 0.17, blue: 0.15, alpha: 1)    // #1B2B27
        static let sageGray = UIColor(red: 0.37, green: 0.45, blue: 0.40, alpha: 1)      // #5F7267
        static let teal = UIColor(red: 0.05, green: 0.58, blue: 0.53, alpha: 1)          // #0D9488
        static let mint = UIColor(red: 0.60, green: 0.96, blue: 0.89, alpha: 1)          // #99F6E4
        static let rose = UIColor(red: 0.88, green: 0.11, blue: 0.28, alpha: 1)          // #E11D48

        // Dark mode
        static let darkBg = UIColor(red: 0.06, green: 0.10, blue: 0.09, alpha: 1)        // #0F1A17
        static let darkCard = UIColor(red: 0.10, green: 0.15, blue: 0.13, alpha: 1)      // #1A2520
        static let lightText = UIColor(red: 0.94, green: 0.95, blue: 0.94, alpha: 1)     // #F0F2EF
        static let lightSageGray = UIColor(red: 0.54, green: 0.61, blue: 0.57, alpha: 1) // #8A9B92
        static let roseLightened = UIColor(red: 0.98, green: 0.44, blue: 0.52, alpha: 1) // #FB7185
    }

    enum Color {
        private static let light = DSLightTheme()
        private static let dark = DSDarkTheme()

        private static func themed(_ keyPath: KeyPath<DSTheme, UIColor>) -> UIColor {
            UIColor { $0.userInterfaceStyle == .dark ? dark[keyPath: keyPath] : light[keyPath: keyPath] }
        }

        // Core
        static let background = themed(\.background)
        static let surfaceCard = themed(\.surfaceCard)
        static let textPrimary = themed(\.textPrimary)
        static let textSecondary = themed(\.textSecondary)
        static let textCaption = themed(\.textCaption)
        static let accent = themed(\.accent)
        static let accentSecondary = themed(\.accentSecondary)
        static let error = themed(\.error)

        // Surfaces
        static let separator = themed(\.separator)
        static let disabled = themed(\.disabled)
        static let progressTrack = themed(\.progressTrack)
        static let fieldBackground = themed(\.fieldBackground)
        static let fieldBorder = themed(\.fieldBorder)

        // Toast
        static let toastBackground = themed(\.toastBackground)
        static let toastText = themed(\.toastText)

        // Buttons
        static let buttonPrimaryBackground = themed(\.buttonPrimaryBackground)
        static let buttonPrimaryText = themed(\.buttonPrimaryText)
        static let buttonSecondaryBackground = themed(\.buttonSecondaryBackground)
        static let buttonSecondaryText = themed(\.buttonSecondaryText)
        static let buttonDestructiveBackground = themed(\.buttonDestructiveBackground)
        static let buttonDestructiveText = themed(\.buttonDestructiveText)
    }
}
