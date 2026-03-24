//
//  UINavigationBar+DS.swift
//  TOTPly-ios
//
//  Created by Matthew on 25.03.2026.
//

import UIKit

extension UINavigationBar {
    static func applyDSAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = DS.Color.background
        navAppearance.titleTextAttributes = [
            .font: TextStyle.headline.font,
            .foregroundColor: DS.Color.textPrimary
        ]
        navAppearance.largeTitleTextAttributes = [
            .font: DSFonts.bold(DS.Size.navLargeTitleSize),
            .foregroundColor: DS.Color.textPrimary
        ]
        navAppearance.shadowColor = DS.Color.separator

        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .font: TextStyle.callout.font,
            .foregroundColor: DS.Color.accent
        ]
        navAppearance.backButtonAppearance = backButtonAppearance

        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = DS.Color.accent
    }
}
