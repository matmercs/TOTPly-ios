//
//  RegistrationViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 03.03.2026.
//

import UIKit

final class RegistrationViewController: UIViewController, RegistrationView {
    private let presenter: RegistrationPresenter

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.keyboardDismissMode = .onDrag
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 16
        s.alignment = .fill
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Регистрация"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        return l
    }()

    private let emailField: UITextField = {
        let t = UITextField()
        t.placeholder = "Почта"
        t.keyboardType = .emailAddress
        t.autocapitalizationType = .none
        t.borderStyle = .roundedRect
        return t
    }()

    private let passwordField: UITextField = {
        let t = UITextField()
        t.placeholder = "Пароль"
        t.isSecureTextEntry = true
        t.borderStyle = .roundedRect
        return t
    }()

    private let displayNameField: UITextField = {
        let t = UITextField()
        t.placeholder = "Имя"
        t.borderStyle = .roundedRect
        return t
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private let registerButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Зарегистрироваться", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.isEnabled = false
        return b
    }()

    private let loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Уже есть аккаунт? Войти", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15)
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
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(displayNameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(loginButton)

        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        displayNameField.addTarget(self, action: #selector(displayNameChanged), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapGoToLogin), for: .touchUpInside)
        
        displayNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self

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
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
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
        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
        registerButton.isEnabled = state.isRegisterButtonEnabled && !state.isLoading
        if state.isLoading {
            registerButton.setTitle("Регистрация…", for: .normal)
        } else {
            registerButton.setTitle("Зарегистрироваться", for: .normal)
        }
    }

    @objc private func emailChanged() {
        presenter.didChangeEmail(emailField.text ?? "")
    }
    
    @objc private func passwordChanged() {
        presenter.didChangePassword(passwordField.text ?? "")
    }
    
    @objc private func displayNameChanged() {
        presenter.didChangeDisplayName(displayNameField.text ?? "")
    }

    @objc private func didTapRegister() {
        view.endEditing(true) // скрыли клавиатуру
        presenter.didTapRegister(email: emailField.text ?? "", password: passwordField.text ?? "", displayName: displayNameField.text?.isEmpty == false ? displayNameField.text : nil)
    }

    @objc private func didTapGoToLogin() {
        presenter.didTapGoToLogin()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === displayNameField {
            emailField.becomeFirstResponder()
        } else if textField === emailField {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            if registerButton.isEnabled {
                didTapRegister()
            }
        }
        return true
    }
}
