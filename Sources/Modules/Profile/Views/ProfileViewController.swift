//
//  ProfileViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 31.03.2026.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileView {
    private let presenter: ProfilePresenter

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

    private lazy var avatarView: UIView = {
        let v = UIView()
        v.backgroundColor = DS.Color.accent
        v.layer.cornerRadius = DS.Size.Avatar.cornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: DS.Size.Avatar.size),
            v.heightAnchor.constraint(equalToConstant: DS.Size.Avatar.size),
        ])
        return v
    }()

    private lazy var avatarLabel: UILabel = {
        let l = UILabel()
        l.font = TextStyle.title1.font
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.apply(.headline)
        return l
    }()

    private lazy var editNameButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "pencil"), for: .normal)
        b.tintColor = DS.Color.accent
        b.addTarget(self, action: #selector(didTapEditName), for: .touchUpInside)
        return b
    }()

    private lazy var emailLabel: UILabel = {
        let l = UILabel()
        l.apply(.footnote)
        l.textColor = DS.Color.textSecondary
        return l
    }()

    private lazy var profileInfoCard: DSCard = {
        let c = DSCard()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()

    private lazy var editNameField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .done,
            onReturnTapped: { [weak self] in
                self?.didTapSaveName()
            }
        ))
    }()

    private lazy var saveNameButton: DSButton = {
        let b = DSButton(style: .primary, title: "Сохранить")
        b.addTarget(self, action: #selector(didTapSaveName), for: .touchUpInside)
        return b
    }()

    private lazy var cancelEditButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = DS.Color.textSecondary
        b.addTarget(self, action: #selector(didTapCancelEditName), for: .touchUpInside)
        return b
    }()

    private lazy var editNameContainer: UIStackView = {
        let s = UIStackView(arrangedSubviews: [editNameField, saveNameButton])
        s.axis = .vertical
        s.spacing = DS.Spacing.m
        s.isHidden = true
        return s
    }()

    private lazy var changePasswordButton: DSButton = {
        let b = DSButton(style: .secondary, title: "Сменить пароль")
        b.addTarget(self, action: #selector(didTapChangePassword), for: .touchUpInside)
        return b
    }()

    private lazy var changeEmailButton: DSButton = {
        let b = DSButton(style: .secondary, title: "Сменить почту")
        b.addTarget(self, action: #selector(didTapChangeEmail), for: .touchUpInside)
        return b
    }()

    private lazy var sessionsHeaderLabel: UILabel = {
        let l = UILabel()
        l.text = "Активные сессии"
        l.apply(.headline)
        return l
    }()

    private lazy var sessionsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = DS.Spacing.s
        return s
    }()

    private lazy var terminateAllButton: DSButton = {
        let b = DSButton(style: .destructive, title: "Завершить все другие сессии")
        b.addTarget(self, action: #selector(didTapTerminateAll), for: .touchUpInside)
        return b
    }()

    private lazy var settingsHeaderLabel: UILabel = {
        let l = UILabel()
        l.text = "Настройки"
        l.apply(.headline)
        return l
    }()

    private lazy var darkModeRow: UIView = {
        makeToggleRow(title: "Тёмная тема", action: #selector(didToggleDarkMode(_:)))
    }()

    private lazy var exportRow: UIView = {
        makeActionRow(title: "Экспорт кодов", action: #selector(didTapExport))
    }()

    private lazy var corporateHeaderLabel: UILabel = {
        let l = UILabel()
        l.text = "Корпоративное"
        l.apply(.headline)
        return l
    }()

    private lazy var organizationLabel: UILabel = {
        makeInfoLabel(title: "Организация")
    }()

    private lazy var securityPolicyLabel: UILabel = {
        makeInfoLabel(title: "Политика безопасности")
    }()

    private lazy var ssoLabel: UILabel = {
        makeInfoLabel(title: "SSO")
    }()

    private lazy var aboutHeaderLabel: UILabel = {
        let l = UILabel()
        l.text = "О приложении"
        l.apply(.headline)
        return l
    }()

    private lazy var versionLabel: UILabel = {
        let l = UILabel()
        l.apply(.footnote)
        l.textColor = DS.Color.textSecondary
        return l
    }()

    private lazy var deleteAccountButton: DSButton = {
        let b = DSButton(style: .destructive, title: "Удалить аккаунт")
        b.addTarget(self, action: #selector(didTapDeleteAccount), for: .touchUpInside)
        return b
    }()

    private lazy var logoutButton: DSButton = {
        let b = DSButton(style: .destructive, title: "Выйти")
        b.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        return b
    }()

    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        title = "Профиль"
        setupUI()
        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        avatarView.addSubview(avatarLabel)
        NSLayoutConstraint.activate([
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
        ])

        let nameRow = UIStackView(arrangedSubviews: [nameLabel, editNameButton])
        nameRow.axis = .horizontal
        nameRow.spacing = DS.Spacing.s
        nameRow.alignment = .center

        let infoStack = UIStackView(arrangedSubviews: [avatarView, nameRow, emailLabel])
        infoStack.axis = .vertical
        infoStack.spacing = DS.Spacing.s
        infoStack.alignment = .center

        profileInfoCard.cardContent.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: profileInfoCard.cardContent.topAnchor, constant: DS.Spacing.xl),
            infoStack.leadingAnchor.constraint(equalTo: profileInfoCard.cardContent.leadingAnchor, constant: DS.Spacing.l),
            infoStack.trailingAnchor.constraint(equalTo: profileInfoCard.cardContent.trailingAnchor, constant: -DS.Spacing.l),
            infoStack.bottomAnchor.constraint(equalTo: profileInfoCard.cardContent.bottomAnchor, constant: -DS.Spacing.xl),
        ])

        editNameField.configure(title: nil, placeholder: "Имя", error: nil, isSecure: false)

        let accountButtonsRow = UIStackView(arrangedSubviews: [changePasswordButton, changeEmailButton])
        accountButtonsRow.axis = .horizontal
        accountButtonsRow.spacing = DS.Spacing.m
        accountButtonsRow.distribution = .fillEqually

        stackView.addArrangedSubview(profileInfoCard)
        stackView.addArrangedSubview(editNameContainer)
        stackView.addArrangedSubview(accountButtonsRow)

        stackView.addArrangedSubview(makeSeparator())
        stackView.addArrangedSubview(sessionsHeaderLabel)
        stackView.addArrangedSubview(sessionsStack)
        stackView.addArrangedSubview(terminateAllButton)

        stackView.addArrangedSubview(makeSeparator())
        stackView.addArrangedSubview(settingsHeaderLabel)
        stackView.addArrangedSubview(darkModeRow)
        stackView.addArrangedSubview(exportRow)

        stackView.addArrangedSubview(makeSeparator())
        stackView.addArrangedSubview(corporateHeaderLabel)
        stackView.addArrangedSubview(organizationLabel)
        stackView.addArrangedSubview(securityPolicyLabel)
        stackView.addArrangedSubview(ssoLabel)

        stackView.addArrangedSubview(makeSeparator())
        stackView.addArrangedSubview(aboutHeaderLabel)
        stackView.addArrangedSubview(versionLabel)

        stackView.addArrangedSubview(makeSeparator())
        stackView.addArrangedSubview(deleteAccountButton)
        stackView.addArrangedSubview(logoutButton)

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

    func render(_ state: ProfileViewState) {
        avatarLabel.text = state.initials
        nameLabel.text = state.userName
        emailLabel.text = state.userEmail
        versionLabel.text = "Версия \(state.appVersion)"

        editNameButton.isHidden = state.isEditingProfile
        editNameContainer.isHidden = !state.isEditingProfile

        if state.isEditingProfile {
            if editNameField.text?.isEmpty ?? true {
                editNameField.text = state.userName
            }
        } else {
            editNameField.text = nil
        }

        rebuildSessions(state.sessions)
        terminateAllButton.isHidden = !state.hasOtherSessions

        if let darkSwitch = darkModeRow.viewWithTag(100) as? UISwitch {
            darkSwitch.isOn = state.isDarkMode
        }

        if state.isDarkMode {
            view.window?.overrideUserInterfaceStyle = .dark
        } else {
            view.window?.overrideUserInterfaceStyle = .light
        }
    }

    private func rebuildSessions(_ sessions: [SessionItem]) {
        sessionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        for session in sessions {
            let card = DSCard()
            card.translatesAutoresizingMaskIntoConstraints = false

            let deviceLabel = UILabel()
            deviceLabel.text = session.deviceName
            deviceLabel.apply(.headline)

            let detailLabel = UILabel()
            detailLabel.text = "\(session.ipAddress) · \(formatter.string(from: session.lastActive))"
            detailLabel.apply(.caption)
            detailLabel.textColor = DS.Color.textSecondary

            let textStack = UIStackView(arrangedSubviews: [deviceLabel, detailLabel])
            textStack.axis = .vertical
            textStack.spacing = DS.Spacing.xxs

            let rowStack = UIStackView(arrangedSubviews: [textStack])
            rowStack.axis = .horizontal
            rowStack.spacing = DS.Spacing.m
            rowStack.alignment = .center

            if session.isCurrent {
                let badge = UILabel()
                badge.text = "Текущая"
                badge.apply(.caption)
                badge.textColor = DS.Color.accent
                rowStack.addArrangedSubview(UIView())
                rowStack.addArrangedSubview(badge)
            } else {
                let terminateButton = UIButton(type: .system)
                terminateButton.setTitle("Завершить", for: .normal)
                terminateButton.titleLabel?.font = TextStyle.caption.font
                terminateButton.setTitleColor(DS.Color.error, for: .normal)
                terminateButton.tag = Int(session.id) ?? 0
                terminateButton.addTarget(self, action: #selector(didTapTerminateSession(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(UIView())
                rowStack.addArrangedSubview(terminateButton)
            }

            rowStack.translatesAutoresizingMaskIntoConstraints = false
            card.cardContent.addSubview(rowStack)
            NSLayoutConstraint.activate([
                rowStack.topAnchor.constraint(equalTo: card.cardContent.topAnchor, constant: DS.Spacing.m),
                rowStack.leadingAnchor.constraint(equalTo: card.cardContent.leadingAnchor, constant: DS.Spacing.m),
                rowStack.trailingAnchor.constraint(equalTo: card.cardContent.trailingAnchor, constant: -DS.Spacing.m),
                rowStack.bottomAnchor.constraint(equalTo: card.cardContent.bottomAnchor, constant: -DS.Spacing.m),
            ])

            sessionsStack.addArrangedSubview(card)
        }
    }

    private func makeToggleRow(title: String, action: Selector) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.apply(.body)
        label.translatesAutoresizingMaskIntoConstraints = false

        let toggle = UISwitch()
        toggle.onTintColor = DS.Color.accent
        toggle.tag = 100
        toggle.addTarget(self, action: action, for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        container.addSubview(toggle)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: DS.Size.Row.height),
        ])

        return container
    }

    private func makeActionRow(title: String, action: Selector) -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = TextStyle.body.font
        button.setTitleColor(DS.Color.accent, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: DS.Size.Row.height).isActive = true
        return button
    }

    private func makeInfoLabel(title: String) -> UILabel {
        let l = UILabel()
        l.text = "\(title): —"
        l.apply(.body)
        l.textColor = DS.Color.textSecondary
        return l
    }

    private func makeSeparator() -> UIView {
        let v = UIView()
        v.backgroundColor = DS.Color.separator
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: DS.Size.Separator.height).isActive = true
        return v
    }

    func showChangePasswordSent() {
        presentAlert(title: "Смена пароля", message: "Код подтверждения отправлен на вашу почту")
    }

    func showChangeEmailSent() {
        presentAlert(title: "Смена почты", message: "Код подтверждения отправлен на текущую почту")
    }

    func showExportUnavailable() {
        presentAlert(title: "Экспорт", message: "Экспорт пока недоступен")
    }

    func showDeleteAccountConfirmation(onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Удалить аккаунт?",
            message: "Все данные будут удалены. Это действие нельзя отменить.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            onConfirm()
        })
        present(alert, animated: true)
    }

    @objc private func didTapEditName() {
        presenter.didTapEditName()
    }

    @objc private func didTapCancelEditName() {
        presenter.didTapCancelEditName()
    }

    @objc private func didTapSaveName() {
        view.endEditing(true)
        presenter.didSaveName(editNameField.text ?? "")
    }

    @objc private func didTapChangePassword() {
        presenter.didTapChangePassword()
    }

    @objc private func didTapChangeEmail() {
        presenter.didTapChangeEmail()
    }

    @objc private func didTapTerminateSession(_ sender: UIButton) {
        presenter.didTapTerminateSession(id: String(sender.tag))
    }

    @objc private func didTapTerminateAll() {
        presenter.didTapTerminateAllOtherSessions()
    }

    @objc private func didToggleDarkMode(_ sender: UISwitch) {
        presenter.didToggleDarkMode(isOn: sender.isOn)
    }

    @objc private func didTapExport() {
        presenter.didTapExportCodes()
    }

    @objc private func didTapDeleteAccount() {
        presenter.didTapDeleteAccount()
    }

    @objc private func didTapLogout() {
        presenter.didTapLogout()
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
