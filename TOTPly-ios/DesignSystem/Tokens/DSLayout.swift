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
        static let buttonHeight: CGFloat = 48
        static let fieldHeight: CGFloat = 44
        static let circularTimerSize: CGFloat = 48
        static let copyButtonSize: CGFloat = 28
        static let accentStripe: CGFloat = 3
        static let toastWidth: CGFloat = 140
        static let toastHeight: CGFloat = 32
        static let navLargeTitleSize: CGFloat = 34
        static let welcomeVerticalOffset: CGFloat = -40
        static let fieldBorderWidth: CGFloat = 1
    }
}
