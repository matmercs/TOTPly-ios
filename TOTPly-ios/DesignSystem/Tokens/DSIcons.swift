//
//  DSIcons.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

extension DS {
    enum Icon {
        enum Size: CGFloat {
            case small = 16
            case medium = 24
            case large = 32
        }

        static let copy = "\u{e1ca}"
        static let refresh = "\u{e036}"
        static let eyeOpen = "\u{e220}"
        static let eyeClosed = "\u{e224}"
        static let profile = "\u{e4c2}"
        static let settings = "\u{e270}"
        static let delete = "\u{e4a6}"
        
        // пока не используются
        static let add = "\u{e3d4}"
        static let search = "\u{e30c}"
        static let lock = "\u{e2fa}"
        static let mail = "\u{e214}"
        static let error = "\u{e4e0}"
        static let empty = "\u{e4aa}"
        static let chevronRight = "\u{e13a}"
        static let shieldCheck = "\u{e40c}"
        static let key = "\u{e2d6}"
        static let signOut = "\u{e42a}"
        static let qrCode = "\u{e3e6}"

        private static let fontName = "Phosphor"

        static func image(_ codepoint: String, size: Size = .medium, tint: UIColor = DS.Color.textPrimary) -> UIImage? {
            
            let fontSize = size.rawValue
            guard let font = UIFont(name: fontName, size: fontSize) else {
                return nil
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: tint
            ]

            let string = NSAttributedString(string: codepoint, attributes: attributes)
            let stringSize = string.size()

            let renderer = UIGraphicsImageRenderer(size: stringSize)
            let image = renderer.image { _ in
                string.draw(at: .zero)
            }

            return image.withRenderingMode(.alwaysOriginal)
        }
    }
}
