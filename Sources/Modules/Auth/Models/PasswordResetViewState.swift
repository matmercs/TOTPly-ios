//
//  PasswordResetViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import Foundation

struct PasswordResetViewState: Equatable {
    enum Step: Equatable {
        case requestReset
        case enterCode
        case newPassword
    }

    var step: Step
    var email: String
    var code: String
    var newPassword: String
    var confirmPassword: String
    var loadingState: LoadingState
    var errorMessage: String?

    static var initial: PasswordResetViewState {
        PasswordResetViewState(
            step: .requestReset,
            email: "",
            code: "",
            newPassword: "",
            confirmPassword: "",
            loadingState: .initial,
            errorMessage: nil
        )
    }

    var canSubmitEmail: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isCodeComplete: Bool {
        code.count == 6
    }

    var canSubmitReset: Bool {
        !newPassword.isEmpty && newPassword == confirmPassword
    }

    var isLoading: Bool {
        loadingState.isLoading
    }

    var passwordMismatch: Bool {
        !confirmPassword.isEmpty && newPassword != confirmPassword
    }
}
