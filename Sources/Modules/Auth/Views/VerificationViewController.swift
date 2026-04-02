//
//  VerificationViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import UIKit

final class VerificationViewController: UIViewController, VerificationView {
    private let presenter: VerificationPresenter

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

    private lazy var iconLabel: UILabel = {
        let l = UILabel()
        l.text = DS.Icon.mail
        l.font = UIFont(name: "Phosphor", size: DS.Icon.Size.xlarge.rawValue)
        l.textColor = DS.Color.accent
        l.textAlignment = .center
        return l
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Подтверждение почты"
        l.apply(.title1)
        l.textAlignment = .center
        return l
    }()

    private lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.apply(.callout)
        l.textColor = DS.Color.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var codeField: DSCodeField = {
        let f = DSCodeField(length: 6)
        f.onCodeChanged = { [weak self] code in
            self?.presenter.didEnterCode(code)
        }
        return f
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        l.textAlignment = .center
        return l
    }()

    private lazy var verifyButton: DSButton = {
        let b = DSButton(style: .primary, title: "Подтвердить")
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTapVerify), for: .touchUpInside)
        return b
    }()

    private lazy var resendButton: UIButton = {
        let b = UIButton(type: .system)
        b.titleLabel?.font = TextStyle.callout.font
        b.setTitleColor(DS.Color.accent, for: .normal)
        b.setTitleColor(DS.Color.textSecondary, for: .disabled)
        b.addTarget(self, action: #selector(didTapResend), for: .touchUpInside)
        return b
    }()

    init(presenter: VerificationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        title = "Верификация"
        setupUI()
        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(iconLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(codeField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(verifyButton)
        stackView.addArrangedSubview(resendButton)

        stackView.setCustomSpacing(DS.Spacing.s, after: iconLabel)
        stackView.setCustomSpacing(DS.Spacing.xl, after: subtitleLabel)

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

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xxl),
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

    func render(_ state: VerificationViewState) {
        subtitleLabel.text = "Код отправлен на \(state.email)"

        verifyButton.isEnabled = state.isCodeComplete && !state.isLoading
        verifyButton.isLoading = state.isLoading

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil

        UIView.performWithoutAnimation {
            if state.canResendCode {
                resendButton.setTitle("Отправить повторно", for: .normal)
                resendButton.isEnabled = true
            } else {
                resendButton.setTitle("Отправить повторно (\(state.resendCooldownSeconds)с)", for: .normal)
                resendButton.isEnabled = false
            }
            resendButton.layoutIfNeeded()
        }
    }

    @objc private func didTapVerify() {
        view.endEditing(true)
        presenter.didTapVerify()
    }

    @objc private func didTapResend() {
        presenter.didTapResendCode()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
