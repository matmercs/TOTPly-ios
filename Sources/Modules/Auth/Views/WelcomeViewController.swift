//
//  WelcomeViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 02.03.2026.
//

import UIKit

final class WelcomeViewController: UIViewController, WelcomeView {
    private let presenter: WelcomePresenter

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DS.Spacing.l
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TOTPly"
        label.apply(.largeTitle)
        label.textAlignment = .center
        label.accessibilityIdentifier = "welcome.title"
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Двухфакторная аутентификация, просто"
        label.apply(.callout)
        label.textColor = DS.Color.textSecondary
        label.textAlignment = .center
        return label
    }()

    private lazy var signInButton: DSButton = {
        let button = DSButton(style: .primary, title: "Войти")
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.accessibilityIdentifier = "welcome.signIn"
        return button
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributed = NSMutableAttributedString(
            string: "Нет аккаунта? ",
            attributes: [
                .font: TextStyle.callout.font,
                .foregroundColor: DS.Color.textSecondary
            ]
        )
        attributed.append(NSAttributedString(
            string: "Регистрация",
            attributes: [
                .font: TextStyle.headline.font,
                .foregroundColor: DS.Color.accent
            ]
        ))
        button.setAttributedTitle(attributed, for: .normal)
        button.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        button.accessibilityIdentifier = "welcome.createAccount"
        return button
    }()

    init(presenter: WelcomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(createAccountButton)
        stackView.setCustomSpacing(DS.Spacing.s, after: titleLabel)
        stackView.setCustomSpacing(DS.Spacing.xxl, after: subtitleLabel)

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: DS.Size.Welcome.verticalOffset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: DS.Spacing.xl),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -DS.Spacing.xl),
        ])
        presenter.viewDidLoad()
    }

    func render(_ state: WelcomeViewState) {
        // статичное вью
    }

    @objc private func didTapSignIn() {
        presenter.didTapSignIn()
    }

    @objc private func didTapCreateAccount() {
        presenter.didTapCreateAccount()
    }
}
