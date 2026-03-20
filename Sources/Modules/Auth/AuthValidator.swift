//
//  AuthValidator.swift
//  TOTPly-ios
//
//  Created by Matthew on 20.03.2026.
//

import Foundation

struct AuthValidator {
    func validateLogin(email: String, password: String) -> LoginViewState.ValidationErrors {
        var errors = LoginViewState.ValidationErrors()

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errors.emailError = "Введите почту"
        } else if !isValidEmail(trimmedEmail) {
            errors.emailError = "Некорректная почта"
        }

        if password.isEmpty {
            errors.passwordError = "Введите пароль"
        }

        return errors
    }

    func validateRegistration(
        email: String,
        password: String,
        confirmPassword: String,
        displayName: String
    ) -> RegistrationViewState.ValidationErrors {
        var errors = RegistrationViewState.ValidationErrors()

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errors.emailError = "Введите почту"
        } else if !isValidEmail(trimmedEmail) {
            errors.emailError = "Некорректная почта"
        }

        if password.isEmpty {
            errors.passwordError = "Введите пароль"
        } else if let strengthError = passwordStrengthError(password) {
            errors.passwordError = strengthError
        }

        if confirmPassword.isEmpty {
            errors.confirmPasswordError = "Повторите пароль"
        } else if confirmPassword != password {
            errors.confirmPasswordError = "Пароли не совпадают"
        }

        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            errors.displayNameError = "Введите имя"
        } else if trimmedName.count < 2 {
            errors.displayNameError = "Слишком короткое имя"
        }

        return errors
    }

    func isValidEmail(_ email: String) -> Bool {
        let parts = email.split(separator: "@")
        guard parts.count == 2, !parts[0].isEmpty else { return false }
        let domainParts = parts[1].split(separator: ".")
        guard domainParts.count >= 2, !domainParts.last!.isEmpty else { return false }
        return true
    }

    func passwordStrengthError(_ password: String) -> String? {
        var requirements: [String] = []
        if password.count < 8 { requirements.append("минимум 8 символов") }
        if !password.contains(where: { $0.isUppercase }) { requirements.append("есть заглавная буква") }
        if !password.contains(where: { $0.isLowercase }) { requirements.append("есть строчная буква") }
        if !password.contains(where: { $0.isNumber }) { requirements.append("есть цифра") }
        let special = CharacterSet.alphanumerics.inverted
        if !password.unicodeScalars.contains(where: { special.contains($0) }) { requirements.append("есть спецсимвол") }
        guard !requirements.isEmpty else { return nil }
        return "Пароль не соответствует требованиям: " + requirements.joined(separator: ", ")
    }
}
