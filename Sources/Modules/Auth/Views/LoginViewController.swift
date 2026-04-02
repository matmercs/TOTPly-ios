//
//  LoginViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class LoginViewController: UIViewController, LoginView {
    private let presenter: LoginPresenter

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
        l.text = "Вход"
        l.apply(.title1)
        l.accessibilityIdentifier = "login.title"
        return l
    }()

    private lazy var emailField: DSTextField = {
        DSTextField(configuration: .init(
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            returnKeyType: .next,
            accessibilityId: "login.email",
            onTextChanged: { [weak self] text in
                self?.presenter.didChangeEmail(text)
            },
            onEditingDidEnd: { [weak self] in
                self?.presenter.didEndEditingEmail()
            },
            onReturnTapped: { [weak self] in
                self?.passwordField.becomeFirstResponder()
            }
        ))
    }()

    private lazy var passwordField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .go,
            accessibilityId: "login.password",
            onTextChanged: { [weak self] text in
                self?.presenter.didChangePassword(text)
            },
            onEditingDidEnd: { [weak self] in
                self?.presenter.didEndEditingPassword()
            },
            onReturnTapped: { [weak self] in
                guard let self = self else { return }
                self.passwordField.resignFirstResponder()
                if self.loginButton.isEnabled {
                    self.didTapLogin()
                }
            }
        ))
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        l.accessibilityIdentifier = "login.error"
        return l
    }()

    private lazy var loginButton: DSButton = {
        let b = DSButton(style: .primary, title: "Войти")
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        b.accessibilityIdentifier = "login.submit"
        return b
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Забыли пароль?", for: .normal)
        b.titleLabel?.font = TextStyle.callout.font
        b.setTitleColor(DS.Color.accent, for: .normal)
        b.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        return b
    }()

    private lazy var registerButton: UIButton = {
        let b = UIButton(type: .system)
        let attributed = NSMutableAttributedString(
            string: "Нет аккаунта? ",
            attributes: [.font: TextStyle.callout.font, .foregroundColor: DS.Color.textSecondary]
        )
        attributed.append(NSAttributedString(
            string: "Регистрация",
            attributes: [.font: TextStyle.headline.font, .foregroundColor: DS.Color.accent]
        ))
        b.setAttributedTitle(attributed, for: .normal)
        b.addTarget(self, action: #selector(didTapGoToRegister), for: .touchUpInside)
        b.accessibilityIdentifier = "login.goToRegister"
        return b
    }()

    init(presenter: LoginPresenter) {
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
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(registerButton)

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
        guard
            let userInfo = note.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let keyboardInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardInView)
        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }

    func render(_ state: LoginViewState) {
        let showEmailError = state.validationErrors.emailError != nil && state.emailTouched
        let showPasswordError = state.validationErrors.passwordError != nil && state.passwordTouched

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

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil

        loginButton.isEnabled = state.isLoginButtonEnabled && !state.isLoading
        loginButton.isLoading = state.isLoading
    }

    @objc private func didTapLogin() {
        view.endEditing(true)
        presenter.didTapLogin(email: emailField.text ?? "", password: passwordField.text ?? "")
    }

    @objc private func didTapForgotPassword() {
        presenter.didTapForgotPassword()
    }

    @objc private func didTapGoToRegister() {
        presenter.didTapGoToRegister()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
