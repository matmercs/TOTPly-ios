//
//  DSTypography.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

enum TextStyle {
    case largeTitle    // 28pt Bold - заголовок Welcome
    case title1        // 24pt Bold - заголовки экранов (Вход, Регистрация)
    case headline      // 17pt SemiBold - кнопки, названия в ячейках
    case body          // 16pt Regular - основной текст, поля ввода
    case callout       // 15pt Regular - подзаголовки, вторичные кнопки
    case subheadline   // 14pt Medium - тост
    case footnote      // 13pt Regular - подписи в ячейках (issuer)
    case caption       // 12pt Regular - ошибки валидации
    case code          // 22pt Bold monospaced - TOTP коды
    case codeSmall     // 13pt Medium monospaced - таймер обратного отсчёта

    var font: UIFont {
        switch self {
        case .largeTitle:   return DSFonts.bold(28)
        case .title1:       return DSFonts.bold(24)
        case .headline:     return DSFonts.semiBold(17)
        case .body:         return DSFonts.regular(16)
        case .callout:      return DSFonts.regular(15)
        case .subheadline:  return DSFonts.medium(14)
        case .footnote:     return DSFonts.regular(13)
        case .caption:      return DSFonts.regular(12)
        case .code:         return DSFonts.monospacedDigits(DSFonts.bold(22))
        case .codeSmall:    return DSFonts.monospacedDigits(DSFonts.medium(13))
        }
    }

    var color: UIColor {
        switch self {
        case .largeTitle, .title1, .headline, .body, .code:
            return DS.Color.textPrimary
        case .callout, .subheadline, .footnote, .codeSmall:
            return DS.Color.textSecondary
        case .caption:
            return DS.Color.textCaption
        }
    }
}

enum DSFonts {
    static func regular(_ size: CGFloat) -> UIFont {
        UIFont(name: "Onest-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }

    static func medium(_ size: CGFloat) -> UIFont {
        UIFont(name: "Onest-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }

    static func semiBold(_ size: CGFloat) -> UIFont {
        UIFont(name: "Onest-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)
    }

    static func bold(_ size: CGFloat) -> UIFont {
        UIFont(name: "Onest-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func monospacedDigits(_ font: UIFont) -> UIFont {
        let descriptor = font.fontDescriptor.addingAttributes([
            .featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
                    UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector
                ]
            ]
        ])
        return UIFont(descriptor: descriptor, size: 0)
    }
}
