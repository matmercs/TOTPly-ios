//
//  PasswordResetViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import UIKit

final class PasswordResetViewController: UIViewController, PasswordResetView {
    private let presenter: PasswordResetPresenter

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
        l.apply(.title1)
        return l
    }()

    private lazy var emailField: DSTextField = {
        DSTextField(configuration: .init(
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            returnKeyType: .go,
            onReturnTapped: { [weak self] in
                self?.didTapSendCode()
            }
        ))
    }()

    private lazy var sendCodeButton: DSButton = {
        let b = DSButton(style: .primary, title: "Отправить код")
        b.addTarget(self, action: #selector(didTapSendCode), for: .touchUpInside)
        return b
    }()

    private lazy var step1Container: UIStackView = {
        let s = UIStackView(arrangedSubviews: [emailField, sendCodeButton])
        s.axis = .vertical
        s.spacing = DS.Spacing.l
        return s
    }()

    private lazy var codeField: DSCodeField = {
        let f = DSCodeField(length: 6)
        f.onCodeChanged = { [weak self] code in
            self?.presenter.didEnterCode(code)
        }
        return f
    }()

    private lazy var verifyCodeButton: DSButton = {
        let b = DSButton(style: .primary, title: "Далее")
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTapVerifyCode), for: .touchUpInside)
        return b
    }()

    private lazy var step2Container: UIStackView = {
        let s = UIStackView(arrangedSubviews: [codeField, verifyCodeButton])
        s.axis = .vertical
        s.spacing = DS.Spacing.l
        s.isHidden = true
        return s
    }()

    private lazy var newPasswordField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .next,
            onReturnTapped: { [weak self] in
                self?.confirmPasswordField.becomeFirstResponder()
            }
        ))
    }()

    private lazy var confirmPasswordField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .go,
            onReturnTapped: { [weak self] in
                self?.didTapResetPassword()
            }
        ))
    }()

    private lazy var resetButton: DSButton = {
        let b = DSButton(style: .primary, title: "Сбросить пароль")
        b.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)
        return b
    }()

    private lazy var step3Container: UIStackView = {
        let s = UIStackView(arrangedSubviews: [newPasswordField, confirmPasswordField, resetButton])
        s.axis = .vertical
        s.spacing = DS.Spacing.l
        s.isHidden = true
        return s
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    init(presenter: PasswordResetPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        title = "Сброс пароля"
        setupUI()
        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        emailField.configure(title: nil, placeholder: "Почта", error: nil, isSecure: false)
        newPasswordField.configure(title: nil, placeholder: "Новый пароль", error: nil, isSecure: true)
        confirmPasswordField.configure(title: nil, placeholder: "Подтверждение пароля", error: nil, isSecure: true)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(step1Container)
        stackView.addArrangedSubview(step2Container)
        stackView.addArrangedSubview(step3Container)
        stackView.addArrangedSubview(errorLabel)

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

    func render(_ state: PasswordResetViewState) {
        step1Container.isHidden = state.step != .requestReset
        step2Container.isHidden = state.step != .enterCode
        step3Container.isHidden = state.step != .newPassword

        switch state.step {
        case .requestReset:
            titleLabel.text = "Восстановление пароля"
            sendCodeButton.isEnabled = !state.isLoading
            sendCodeButton.isLoading = state.isLoading
            navigationItem.hidesBackButton = false
            navigationItem.leftBarButtonItem = nil
        case .enterCode:
            titleLabel.text = "Введите код"
            verifyCodeButton.isEnabled = state.isCodeComplete && !state.isLoading
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(didTapBack)
            )
            navigationItem.leftBarButtonItem?.tintColor = DS.Color.accent
        case .newPassword:
            titleLabel.text = "Новый пароль"
            resetButton.isEnabled = !state.isLoading
            resetButton.isLoading = state.isLoading
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(didTapBack)
            )
            navigationItem.leftBarButtonItem?.tintColor = DS.Color.accent
        }

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
    }

    @objc private func didTapSendCode() {
        view.endEditing(true)
        presenter.didTapSendResetCode(email: emailField.text ?? "")
    }

    @objc private func didTapVerifyCode() {
        view.endEditing(true)
        presenter.didTapVerifyCode()
    }

    @objc private func didTapResetPassword() {
        view.endEditing(true)
        presenter.didTapResetPassword(
            newPassword: newPasswordField.text ?? "",
            confirmPassword: confirmPasswordField.text ?? ""
        )
    }

    @objc private func didTapBack() {
        presenter.didTapBack()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
