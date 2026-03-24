//
//  DSButton.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

final class DSButton: UIButton {
    enum Style {
        case primary
        case secondary
        case destructive
        case text
    }

    private let style: Style
    private lazy var spinner = UIActivityIndicatorView(style: .medium)
    private var baseBackgroundColor: UIColor = .clear

    var isLoading: Bool = false {
        didSet {
            isUserInteractionEnabled = !isLoading
            if isLoading {
                titleLabel?.alpha = 0
                spinner.startAnimating()
            } else {
                titleLabel?.alpha = 1
                spinner.stopAnimating()
            }
            updateAppearance()
        }
    }

    override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }

    init(style: Style, title: String) {
        self.style = style
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: DS.Spacing.l,
            bottom: 0,
            trailing: DS.Spacing.l
        )
        configuration = config

        titleLabel?.font = TextStyle.headline.font
        layer.cornerRadius = DS.CornerRadius.small
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: DS.Size.buttonHeight).isActive = true

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        applyStyle()
    }

    private func applyStyle() {
        switch style {
        case .primary:
            baseBackgroundColor = DS.Color.buttonPrimaryBackground
            setTitleColor(DS.Color.buttonPrimaryText, for: .normal)
            spinner.color = DS.Color.buttonPrimaryText
        case .secondary:
            baseBackgroundColor = DS.Color.buttonSecondaryBackground
            setTitleColor(DS.Color.buttonSecondaryText, for: .normal)
            spinner.color = DS.Color.buttonSecondaryText
        case .destructive:
            baseBackgroundColor = DS.Color.buttonDestructiveBackground
            setTitleColor(DS.Color.buttonDestructiveText, for: .normal)
            spinner.color = DS.Color.buttonDestructiveText
        case .text:
            baseBackgroundColor = .clear
            setTitleColor(DS.Color.accent, for: .normal)
            spinner.color = DS.Color.accent
        }
        backgroundColor = baseBackgroundColor
    }

    private func updateAppearance() {
        let disabled = !isEnabled || isLoading
        backgroundColor = disabled ? baseBackgroundColor.withAlphaComponent(0.4) : baseBackgroundColor
    }
}
