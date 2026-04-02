//
//  ProfileViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

struct ProfileViewState: Equatable {
    var loadingState: LoadingState
    var userName: String
    var userEmail: String
    var isEditingProfile: Bool
    var editedName: String
    var editedEmail: String
    var sessions: [SessionItem]
    var isDarkMode: Bool
    var appVersion: String

    static var initial: ProfileViewState {
        ProfileViewState(
            loadingState: .initial,
            userName: "",
            userEmail: "",
            isEditingProfile: false,
            editedName: "",
            editedEmail: "",
            sessions: [],
            isDarkMode: false,
            appVersion: "1.0.0"
        )
    }

    var hasOtherSessions: Bool {
        sessions.contains(where: { !$0.isCurrent })
    }

    var canSaveProfile: Bool {
        !editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !editedEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var initials: String {
        let parts = userName.split(separator: " ")
        let firstInitial = parts.first?.first.map(String.init) ?? ""
        let lastInitial = parts.count > 1 ? parts.last?.first.map(String.init) ?? "" : ""
        return (firstInitial + lastInitial).uppercased()
    }
}
