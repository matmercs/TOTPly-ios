//
//  CodeDetailViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class CodeDetailViewController: UIViewController, CodeDetailView {
    private let presenter: CodeDetailPresenter

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

    private lazy var codeCard: DSCard = {
        let c = DSCard()
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()

    private lazy var codeLabel: UILabel = {
        let l = UILabel()
        l.apply(.code)
        l.textColor = DS.Color.accent
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var circularProgress: DSCircularProgress = {
        let v = DSCircularProgress()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.apply(.headline)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var issuerLabel: UILabel = {
        let l = UILabel()
        l.apply(.footnote)
        l.textColor = DS.Color.textSecondary
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var copyButton: DSButton = {
        let b = DSButton(style: .primary, title: "Скопировать код")
        b.addTarget(self, action: #selector(didTapCopy), for: .touchUpInside)
        return b
    }()

    private lazy var editNameField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .next,
            onReturnTapped: { [weak self] in
                self?.editIssuerField.becomeFirstResponder()
            }
        ))
    }()

    private lazy var editIssuerField: DSTextField = {
        DSTextField(configuration: .init(
            returnKeyType: .done,
            onReturnTapped: { [weak self] in
                self?.editIssuerField.resignFirstResponder()
            }
        ))
    }()

    private lazy var saveButton: DSButton = {
        let b = DSButton(style: .primary, title: "Сохранить")
        b.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return b
    }()

    private lazy var deleteButton: DSButton = {
        let b = DSButton(style: .destructive, title: "Удалить")
        b.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        return b
    }()

    private lazy var editContainer: UIStackView = {
        let s = UIStackView(arrangedSubviews: [editNameField, editIssuerField, saveButton, deleteButton])
        s.axis = .vertical
        s.spacing = DS.Spacing.l
        s.isHidden = true
        return s
    }()

    init(presenter: CodeDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        title = "Детейл"
        setupNavigationBar()
        setupUI()
        setupKeyboardObservers()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }

    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapShare)
        )
        shareButton.tintColor = DS.Color.accent
        editButton.tintColor = DS.Color.accent
        navigationItem.rightBarButtonItems = [editButton, shareButton]
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        let codeStack = UIStackView(arrangedSubviews: [codeLabel, circularProgress])
        codeStack.axis = .vertical
        codeStack.spacing = DS.Spacing.m
        codeStack.alignment = .center

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, issuerLabel])
        infoStack.axis = .vertical
        infoStack.spacing = DS.Spacing.xs

        codeCard.cardContent.addSubview(codeStack)
        codeCard.cardContent.addSubview(infoStack)
        codeStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            codeStack.topAnchor.constraint(equalTo: codeCard.cardContent.topAnchor, constant: DS.Spacing.xl),
            codeStack.centerXAnchor.constraint(equalTo: codeCard.cardContent.centerXAnchor),

            circularProgress.widthAnchor.constraint(equalToConstant: DS.Size.CircularTimer.size),
            circularProgress.heightAnchor.constraint(equalToConstant: DS.Size.CircularTimer.size),

            infoStack.topAnchor.constraint(equalTo: codeStack.bottomAnchor, constant: DS.Spacing.l),
            infoStack.leadingAnchor.constraint(equalTo: codeCard.cardContent.leadingAnchor, constant: DS.Spacing.l),
            infoStack.trailingAnchor.constraint(equalTo: codeCard.cardContent.trailingAnchor, constant: -DS.Spacing.l),
            infoStack.bottomAnchor.constraint(equalTo: codeCard.cardContent.bottomAnchor, constant: -DS.Spacing.xl),
        ])

        stackView.addArrangedSubview(codeCard)
        stackView.addArrangedSubview(copyButton)
        stackView.addArrangedSubview(editContainer)

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

    func render(_ state: CodeDetailViewState) {
        codeLabel.text = state.formattedCode
        nameLabel.text = state.displayName
        issuerLabel.text = state.item?.issuer
        issuerLabel.isHidden = state.item?.issuer.isEmpty ?? true

        circularProgress.configure(
            progress: state.progressPercentage,
            timeText: "\(state.timeRemaining)s",
            isExpiring: state.isExpiringSoon
        )

        if state.isExpiringSoon {
            codeLabel.textColor = DS.Color.error
        } else {
            codeLabel.textColor = DS.Color.accent
        }

        editContainer.isHidden = !state.isEditing
        copyButton.isHidden = state.isEditing

        if state.isEditing {
            editNameField.configure(title: nil, placeholder: "Название", error: nil, isSecure: false)
            editIssuerField.configure(title: nil, placeholder: "Издатель", error: nil, isSecure: false)
            if editNameField.text?.isEmpty ?? true {
                editNameField.text = state.item?.name
            }
            if editIssuerField.text?.isEmpty ?? true {
                editIssuerField.text = state.item?.issuer
            }
            navigationItem.rightBarButtonItems?.first?.image = UIImage(systemName: "xmark")
        } else {
            editNameField.text = nil
            editIssuerField.text = nil
            navigationItem.rightBarButtonItems?.first?.image = UIImage(systemName: "pencil")
        }

        deleteButton.isEnabled = state.canDelete
    }

    func copyCodeToClipboard(_ code: String) {
        UIPasteboard.general.string = code
        showCopiedToast()
    }

    func showShareSheet(text: String) {
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(ac, animated: true)
    }

    func showDeleteConfirmation(onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Удалить код?",
            message: "Это действие нельзя отменить",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
            onConfirm()
        })
        present(alert, animated: true)
    }

    private func showCopiedToast() {
        let toast = UILabel()
        toast.text = "Скопировано"
        toast.font = TextStyle.subheadline.font
        toast.textColor = DS.Color.toastText
        toast.backgroundColor = DS.Color.toastBackground
        toast.textAlignment = .center
        toast.layer.cornerRadius = DS.CornerRadius.large
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0

        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DS.Size.Toast.bottomOffset),
            toast.widthAnchor.constraint(equalToConstant: DS.Size.Toast.width),
            toast.heightAnchor.constraint(equalToConstant: DS.Size.Toast.height),
        ])

        UIView.animate(withDuration: 0.2, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.8, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }

    @objc private func didTapCopy() {
        presenter.didTapCopyCode()
    }

    @objc private func didTapEdit() {
        if editContainer.isHidden {
            presenter.didTapEdit()
        } else {
            presenter.didTapCancelEdit()
        }
    }

    @objc private func didTapShare() {
        presenter.didTapShare()
    }

    @objc private func didTapSave() {
        view.endEditing(true)
        presenter.didSave(name: editNameField.text ?? "", issuer: editIssuerField.text ?? "")
    }

    @objc private func didTapDelete() {
        presenter.didTapDelete()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
