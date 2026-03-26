//
//  DSLayout.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

extension DS {
    enum Spacing {
        static let xxs: CGFloat = 2   // между строками в стеке
        static let xs: CGFloat = 4    // вертикальный inset карточек
        static let s: CGFloat = 8     // между мелкими элементами
        static let m: CGFloat = 12    // padding внутри карточки
        static let l: CGFloat = 16    // padding от краёв экрана
        static let xl: CGFloat = 24   // отступы формы
        static let xxl: CGFloat = 32  // между крупными секциями
    }

    enum CornerRadius {
        static let small: CGFloat = 8   // кнопки, поля ввода
        static let medium: CGFloat = 12 // карточки
        static let large: CGFloat = 16  // тост
    }

    enum Size {
        enum Button {
            static let height: CGFloat = 48
        }
        enum Field {
            static let height: CGFloat = 44
            static let borderWidth: CGFloat = 1
        }
        enum CircularTimer {
            static let size: CGFloat = 48
            static let lineWidth: CGFloat = 3.5
            static let fontSize: CGFloat = 14
        }
        enum Toast {
            static let width: CGFloat = 140
            static let height: CGFloat = 32
            static let bottomOffset: CGFloat = -20
        }
        enum Cell {
            static let estimatedHeight: CGFloat = 80
            static let accentStripe: CGFloat = 3
            static let copyButtonSize: CGFloat = 28
        }
        enum Nav {
            static let largeTitleSize: CGFloat = 34
        }
        enum Welcome {
            static let verticalOffset: CGFloat = -40
        }
    }
}
