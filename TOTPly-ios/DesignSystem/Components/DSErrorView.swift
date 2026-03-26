//
//  DSErrorView.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

final class DSErrorView: UIView {
    var onRetryTapped: (() -> Void)?

    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = DS.Icon.image(DS.Icon.error, size: .large, tint: DS.Color.error)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.apply(.body)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var retryButton: DSButton = {
        let b = DSButton(style: .primary, title: "Повторить")
        b.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [iconView, messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.l
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.xxl),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.xxl),
            retryButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
        ])
    }

    func configure(message: String, retryTitle: String? = "Повторить") {
        messageLabel.text = message
        if let retryTitle = retryTitle {
            retryButton.setTitle(retryTitle, for: .normal)
            retryButton.isHidden = false
        } else {
            retryButton.isHidden = true
        }
    }

    @objc private func retryTapped() {
        onRetryTapped?()
    }
}
