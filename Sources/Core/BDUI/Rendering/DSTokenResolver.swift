//
//  DSTokenResolver.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

enum DSTokenResolver {

    static func spacing(_ name: String) -> CGFloat {
        switch name {
        case "xxs": return DS.Spacing.xxs
        case "xs":  return DS.Spacing.xs
        case "s":   return DS.Spacing.s
        case "m":   return DS.Spacing.m
        case "l":   return DS.Spacing.l
        case "xl":  return DS.Spacing.xl
        case "xxl": return DS.Spacing.xxl
        default:    return DS.Spacing.m
        }
    }

    static func color(_ name: String) -> UIColor {
        switch name {
        case "background":                  return DS.Color.background
        case "surfaceCard":                 return DS.Color.surfaceCard
        case "textPrimary":                 return DS.Color.textPrimary
        case "textSecondary":               return DS.Color.textSecondary
        case "textCaption":                 return DS.Color.textCaption
        case "accent":                      return DS.Color.accent
        case "accentSecondary":             return DS.Color.accentSecondary
        case "error":                       return DS.Color.error
        case "separator":                   return DS.Color.separator
        case "disabled":                    return DS.Color.disabled
        case "progressTrack":               return DS.Color.progressTrack
        case "fieldBackground":             return DS.Color.fieldBackground
        case "fieldBorder":                 return DS.Color.fieldBorder
        case "toastBackground":             return DS.Color.toastBackground
        case "toastText":                   return DS.Color.toastText
        case "buttonPrimaryBackground":     return DS.Color.buttonPrimaryBackground
        case "buttonPrimaryText":           return DS.Color.buttonPrimaryText
        case "buttonSecondaryBackground":   return DS.Color.buttonSecondaryBackground
        case "buttonSecondaryText":         return DS.Color.buttonSecondaryText
        case "buttonDestructiveBackground": return DS.Color.buttonDestructiveBackground
        case "buttonDestructiveText":       return DS.Color.buttonDestructiveText
        case "white":                       return .white
        case "black":                       return .black
        case "clear":                       return .clear
        default:                            return DS.Color.textPrimary
        }
    }

    static func textStyle(_ name: String) -> TextStyle {
        switch name {
        case "largeTitle":  return .largeTitle
        case "title1":      return .title1
        case "headline":    return .headline
        case "body":        return .body
        case "callout":     return .callout
        case "subheadline": return .subheadline
        case "footnote":    return .footnote
        case "caption":     return .caption
        case "code":        return .code
        case "codeSmall":   return .codeSmall
        default:            return .body
        }
    }

    static func cornerRadius(_ name: String) -> CGFloat {
        switch name {
        case "small":  return DS.CornerRadius.small
        case "medium": return DS.CornerRadius.medium
        case "large":  return DS.CornerRadius.large
        default:       return DS.CornerRadius.small
        }
    }

    static func icon(_ name: String) -> String {
        switch name {
        case "copy":         return DS.Icon.copy
        case "refresh":      return DS.Icon.refresh
        case "eyeOpen":      return DS.Icon.eyeOpen
        case "eyeClosed":    return DS.Icon.eyeClosed
        case "profile":      return DS.Icon.profile
        case "settings":     return DS.Icon.settings
        case "delete":       return DS.Icon.delete
        case "add":          return DS.Icon.add
        case "search":       return DS.Icon.search
        case "lock":         return DS.Icon.lock
        case "mail":         return DS.Icon.mail
        case "error":        return DS.Icon.error
        case "empty":        return DS.Icon.empty
        case "chevronRight": return DS.Icon.chevronRight
        case "shieldCheck":  return DS.Icon.shieldCheck
        case "key":          return DS.Icon.key
        case "signOut":      return DS.Icon.signOut
        case "qrCode":       return DS.Icon.qrCode
        default:             return DS.Icon.error
        }
    }

    static func iconSize(_ name: String) -> DS.Icon.Size {
        switch name {
        case "small":  return .small
        case "medium": return .medium
        case "large":  return .large
        case "xlarge": return .xlarge
        default:       return .medium
        }
    }

    static func buttonStyle(_ name: String) -> DSButton.Style {
        switch name {
        case "primary":     return .primary
        case "secondary":   return .secondary
        case "destructive": return .destructive
        case "text":        return .text
        default:            return .primary
        }
    }

    static func stackAlignment(_ name: String) -> UIStackView.Alignment {
        switch name {
        case "fill":      return .fill
        case "leading":   return .leading
        case "trailing":  return .trailing
        case "center":    return .center
        case "top":       return .top
        case "bottom":    return .bottom
        default:          return .fill
        }
    }

    static func stackDistribution(_ name: String) -> UIStackView.Distribution {
        switch name {
        case "fill":            return .fill
        case "fillEqually":     return .fillEqually
        case "fillProportionally": return .fillProportionally
        case "equalSpacing":    return .equalSpacing
        case "equalCentering":  return .equalCentering
        default:                return .fill
        }
    }

    static func textAlignment(_ name: String) -> NSTextAlignment {
        switch name {
        case "left":    return .left
        case "center":  return .center
        case "right":   return .right
        case "natural": return .natural
        default:        return .natural
        }
    }
}
