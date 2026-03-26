//
//  DSEmptyView.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

final class DSEmptyView: UIView {
    private lazy var iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.apply(.headline)
        l.textAlignment = .center
        l.numberOfLines = 0
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.s
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

    func configure(icon: String?, title: String, subtitle: String?) {
        if let icon = icon {
            iconView.image = DS.Icon.image(icon, size: .large, tint: DS.Color.textSecondary)
            iconView.isHidden = false
        } else {
            iconView.isHidden = true
        }
        titleLabel.text = title
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
}
