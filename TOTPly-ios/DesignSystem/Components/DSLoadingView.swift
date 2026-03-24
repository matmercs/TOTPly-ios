//
//  DSLoadingView.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

final class DSLoadingView: UIView {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = DS.Color.accent
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.apply(.callout)
        l.textColor = DS.Color.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [activityIndicator, messageLabel])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.m
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.xxl),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.xxl),
        ])
    }

    func configure(message: String?) {
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        activityIndicator.startAnimating()
    }
}
