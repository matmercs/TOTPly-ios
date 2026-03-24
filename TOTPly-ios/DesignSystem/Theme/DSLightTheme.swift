//
//  DSLightTheme.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

struct DSLightTheme: DSTheme {
    let background = DS.Palette.sageMist
    let surfaceCard = DS.Palette.white
    let textPrimary = DS.Palette.deepForest
    let textSecondary = DS.Palette.sageGray
    let textCaption = DS.Palette.deepForest.withAlphaComponent(0.45)
    let accent = DS.Palette.teal
    let accentSecondary = DS.Palette.mint
    let error = DS.Palette.rose

    let separator = DS.Palette.deepForest.withAlphaComponent(0.08)
    let disabled = DS.Palette.deepForest.withAlphaComponent(0.25)
    let progressTrack = DS.Palette.deepForest.withAlphaComponent(0.06)
    let fieldBackground = DS.Palette.white
    let fieldBorder = DS.Palette.deepForest.withAlphaComponent(0.12)

    let toastBackground = DS.Palette.deepForest.withAlphaComponent(0.85)
    let toastText = DS.Palette.lightText

    let buttonPrimaryBackground = DS.Palette.teal
    let buttonPrimaryText = DS.Palette.white
    let buttonSecondaryBackground = DS.Palette.sageMist
    let buttonSecondaryText = DS.Palette.deepForest
    let buttonDestructiveBackground = DS.Palette.rose
    let buttonDestructiveText = DS.Palette.white
}
