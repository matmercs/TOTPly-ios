//
//  RegistrationViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class RegistrationViewController: UIViewController, RegistrationView {
    private let presenter: RegistrationPresenter

    private lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.keyboardDismissMode = .onDrag
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = DS.Spacing.l
        s.alignment = .fill
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Регистрация"
        l.apply(.title1)
        return l
    }()

    private lazy var displayNameField: DSTextField = {
        let f = DSTextField()
        f.returnKeyType = .next
        f.onTextChanged = { [weak self] text in
            self?.presenter.didChangeDisplayName(text)
        }
        f.onEditingDidEnd = { [weak self] in
            self?.presenter.didEndEditingDisplayName()
        }
        f.onReturnTapped = { [weak self] in
            self?.emailField.becomeFirstResponder()
        }
        return f
    }()

    private lazy var emailField: DSTextField = {
        let f = DSTextField()
        f.keyboardType = .emailAddress
        f.autocapitalizationType = .none
        f.returnKeyType = .next
        f.onTextChanged = { [weak self] text in
            self?.presenter.didChangeEmail(text)
        }
        f.onEditingDidEnd = { [weak self] in
            self?.presenter.didEndEditingEmail()
        }
        f.onReturnTapped = { [weak self] in
            self?.passwordField.becomeFirstResponder()
        }
        return f
    }()

    private lazy var passwordField: DSTextField = {
        let f = DSTextField()
        f.returnKeyType = .next
        f.onTextChanged = { [weak self] text in
            self?.presenter.didChangePassword(text)
        }
        f.onEditingDidEnd = { [weak self] in
            self?.presenter.didEndEditingPassword()
        }
        f.onReturnTapped = { [weak self] in
            self?.confirmPasswordField.becomeFirstResponder()
        }
        return f
    }()

    private lazy var confirmPasswordField: DSTextField = {
        let f = DSTextField()
        f.returnKeyType = .go
        f.onTextChanged = { [weak self] text in
            self?.presenter.didChangeConfirmPassword(text)
        }
        f.onEditingDidEnd = { [weak self] in
            self?.presenter.didEndEditingConfirmPassword()
        }
        f.onReturnTapped = { [weak self] in
            guard let self = self else { return }
            _ = self.confirmPasswordField.resignFirstResponder()
            if self.registerButton.isEnabled {
                self.didTapRegister()
            }
        }
        return f
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private lazy var registerButton: DSButton = {
        let b = DSButton(style: .primary, title: "Зарегистрироваться")
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return b
    }()

    private lazy var loginButton: UIButton = {
        let b = UIButton(type: .system)
        let attributed = NSMutableAttributedString(
            string: "Уже есть аккаунт? ",
            attributes: [.font: TextStyle.callout.font, .foregroundColor: DS.Color.textSecondary]
        )
        attributed.append(NSAttributedString(
            string: "Войти",
            attributes: [.font: TextStyle.headline.font, .foregroundColor: DS.Color.accent]
        ))
        b.setAttributedTitle(attributed, for: .normal)
        b.addTarget(self, action: #selector(didTapGoToLogin), for: .touchUpInside)
        return b
    }()

    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(displayNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xl),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.xl),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.xl),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl),
        ])

        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(_ note: Notification) {
        guard let userInfo = note.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)
        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    func render(_ state: RegistrationViewState) {
        let showDisplayNameError = state.validationErrors.displayNameError != nil && state.displayNameTouched
        let showEmailError = state.validationErrors.emailError != nil && state.emailTouched
        let showPasswordError = state.validationErrors.passwordError != nil && state.passwordTouched
        let showConfirmPasswordError = state.validationErrors.confirmPasswordError != nil && state.confirmPasswordTouched

        displayNameField.configure(
            title: nil,
            placeholder: "Имя",
            error: showDisplayNameError ? state.validationErrors.displayNameError : nil,
            isSecure: false
        )

        emailField.configure(
            title: nil,
            placeholder: "Почта",
            error: showEmailError ? state.validationErrors.emailError : nil,
            isSecure: false
        )

        passwordField.configure(
            title: nil,
            placeholder: "Пароль",
            error: showPasswordError ? state.validationErrors.passwordError : nil,
            isSecure: true
        )

        confirmPasswordField.configure(
            title: nil,
            placeholder: "Повторите пароль",
            error: showConfirmPasswordError ? state.validationErrors.confirmPasswordError : nil,
            isSecure: true
        )

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil

        registerButton.isEnabled = state.isRegisterButtonEnabled && !state.isLoading
        registerButton.isLoading = state.isLoading
    }

    @objc private func didTapRegister() {
        view.endEditing(true)
        presenter.didTapRegister(
            email: emailField.text ?? "",
            password: passwordField.text ?? "",
            confirmPassword: confirmPasswordField.text ?? "",
            displayName: displayNameField.text?.isEmpty == false ? displayNameField.text : nil
        )
    }

    @objc private func didTapGoToLogin() {
        presenter.didTapGoToLogin()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
