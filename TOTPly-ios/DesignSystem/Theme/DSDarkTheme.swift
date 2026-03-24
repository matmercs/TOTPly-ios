//
//  DSDarkTheme.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

struct DSDarkTheme: DSTheme {
    let background = DS.Palette.darkBg
    let surfaceCard = DS.Palette.darkCard
    let textPrimary = DS.Palette.lightText
    let textSecondary = DS.Palette.lightSageGray
    let textCaption = DS.Palette.lightText.withAlphaComponent(0.45)
    let accent = DS.Palette.teal
    let accentSecondary = DS.Palette.mint
    let error = DS.Palette.roseLightened

    let separator = DS.Palette.lightText.withAlphaComponent(0.10)
    let disabled = DS.Palette.lightText.withAlphaComponent(0.25)
    let progressTrack = DS.Palette.lightText.withAlphaComponent(0.08)
    let fieldBackground = DS.Palette.darkCard
    let fieldBorder = DS.Palette.lightText.withAlphaComponent(0.12)

    let toastBackground = DS.Palette.lightText.withAlphaComponent(0.85)
    let toastText = DS.Palette.deepForest

    let buttonPrimaryBackground = DS.Palette.teal
    let buttonPrimaryText = DS.Palette.white
    let buttonSecondaryBackground = DS.Palette.darkCard
    let buttonSecondaryText = DS.Palette.lightText
    let buttonDestructiveBackground = DS.Palette.roseLightened
    let buttonDestructiveText = DS.Palette.white
}

