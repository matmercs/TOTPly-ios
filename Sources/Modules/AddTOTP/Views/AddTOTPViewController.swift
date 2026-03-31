//
//  AddTOTPViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class AddTOTPViewController: UIViewController, AddTOTPView {
    private let presenter: AddTOTPPresenter

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
        l.text = "Добавить TOTP"
        l.apply(.title1)
        return l
    }()

    private lazy var nameField: DSTextField = {
        DSTextField(configuration: .init(
            autocapitalizationType: .words,
            returnKeyType: .next,
            onReturnTapped: { [weak self] in
                self?.issuerField.becomeFirstResponder()
            }
        ))
    }()

    private lazy var issuerField: DSTextField = {
        DSTextField(configuration: .init(
            autocapitalizationType: .words,
            returnKeyType: .next,
            onReturnTapped: { [weak self] in
                self?.secretField.becomeFirstResponder()
            }
        ))
    }()

    private lazy var secretField: DSTextField = {
        DSTextField(configuration: .init(
            autocapitalizationType: .none,
            returnKeyType: .done,
            onReturnTapped: { [weak self] in
                self?.secretField.resignFirstResponder()
            }
        ))
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private lazy var scanQRButton: DSButton = {
        let b = DSButton(style: .secondary, title: "Сканировать QR")
        b.addTarget(self, action: #selector(didTapScanQR), for: .touchUpInside)
        return b
    }()

    private lazy var saveButton: DSButton = {
        let b = DSButton(style: .primary, title: "Сохранить")
        b.isEnabled = false
        b.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return b
    }()

    init(presenter: AddTOTPPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        title = "Новый код"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.leftBarButtonItem?.tintColor = DS.Color.accent

        setupUI()
        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        nameField.configure(title: nil, placeholder: "Название", error: nil, isSecure: false)
        issuerField.configure(title: nil, placeholder: "Издатель (опционально)", error: nil, isSecure: false)
        secretField.configure(title: nil, placeholder: "Секретный ключ", error: nil, isSecure: false)

        let orLabel = UILabel()
        orLabel.text = "или"
        orLabel.apply(.callout)
        orLabel.textColor = DS.Color.textSecondary
        orLabel.textAlignment = .center

        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(issuerField)
        stackView.addArrangedSubview(secretField)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(saveButton)
        stackView.addArrangedSubview(orLabel)
        stackView.addArrangedSubview(scanQRButton)

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

    func render(_ state: AddTOTPViewState) {
        saveButton.isEnabled = state.canSave && !state.isSaving
        saveButton.isLoading = state.isSaving

        errorLabel.text = state.errorMessage
        errorLabel.isHidden = state.errorMessage == nil
    }

    func fillFields(name: String, issuer: String, secret: String) {
        nameField.text = name
        issuerField.text = issuer
        secretField.text = secret
    }

    @objc private func didTapCancel() {
        presenter.didTapCancel()
    }

    @objc private func didTapScanQR() {
        presenter.didTapScanQR()
    }

    @objc private func didTapSave() {
        view.endEditing(true)
        presenter.didSave(
            name: nameField.text ?? "",
            issuer: issuerField.text ?? "",
            secret: secretField.text ?? ""
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
