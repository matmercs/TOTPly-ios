//
//  TOTPCell.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class TOTPCell: UITableViewCell {
    static let reuseIdentifier = "TOTPCell"

    private lazy var card = DSCard()

    private lazy var accentStripe: UIView = {
        let v = UIView()
        v.backgroundColor = DS.Color.accent
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = DS.Size.Cell.accentStripe / 2
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.apply(.headline)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var subtitleLabel: UILabel = {
        let l = UILabel()
        l.apply(.footnote)
        l.textColor = DS.Color.textSecondary
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var codeLabel: UILabel = {
        let l = UILabel()
        l.apply(.code)
        l.textColor = DS.Color.accent
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var copyButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(DS.Icon.image(DS.Icon.copy, size: .medium, tint: DS.Color.textSecondary), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private lazy var circularProgress: DSCircularProgress = {
        let v = DSCircularProgress()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    var onCopyTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // потому что это фон именно ячейки а не карточки
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = DS.Spacing.xxs
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let codeRow = UIStackView(arrangedSubviews: [codeLabel, copyButton])
        codeRow.axis = .horizontal
        codeRow.spacing = DS.Spacing.s
        codeRow.alignment = .center
        codeRow.translatesAutoresizingMaskIntoConstraints = false

        card.cardContent.addSubview(accentStripe)
        card.cardContent.addSubview(textStack)
        card.cardContent.addSubview(codeRow)
        card.cardContent.addSubview(circularProgress)

        let padding = DS.Spacing.l

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.xs),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xs),

            accentStripe.leadingAnchor.constraint(equalTo: card.cardContent.leadingAnchor),
            accentStripe.topAnchor.constraint(equalTo: card.cardContent.topAnchor, constant: DS.Spacing.s),
            accentStripe.bottomAnchor.constraint(equalTo: card.cardContent.bottomAnchor, constant: -DS.Spacing.s),
            accentStripe.widthAnchor.constraint(equalToConstant: DS.Size.Cell.accentStripe),

            textStack.topAnchor.constraint(equalTo: card.cardContent.topAnchor, constant: padding),
            textStack.leadingAnchor.constraint(equalTo: accentStripe.trailingAnchor, constant: DS.Spacing.m),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: circularProgress.leadingAnchor, constant: -DS.Spacing.m),

            // Code + copy row
            codeRow.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: DS.Spacing.s),
            codeRow.leadingAnchor.constraint(equalTo: textStack.leadingAnchor),
            codeRow.bottomAnchor.constraint(equalTo: card.cardContent.bottomAnchor, constant: -padding),

            circularProgress.centerYAnchor.constraint(equalTo: card.cardContent.centerYAnchor),
            circularProgress.trailingAnchor.constraint(equalTo: card.cardContent.trailingAnchor, constant: -padding),
            circularProgress.widthAnchor.constraint(equalToConstant: DS.Size.CircularTimer.size),
            circularProgress.heightAnchor.constraint(equalToConstant: DS.Size.CircularTimer.size),

            copyButton.widthAnchor.constraint(equalToConstant: DS.Size.Cell.copyButtonSize),
            copyButton.heightAnchor.constraint(equalToConstant: DS.Size.Cell.copyButtonSize),
        ])
    }

    @objc private func copyTapped() {
        onCopyTapped?()
    }

    func configure(with viewModel: TOTPCellModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle == nil
        codeLabel.text = viewModel.code

        circularProgress.configure(
            progress: viewModel.progress,
            timeText: viewModel.timeRemaining,
            isExpiring: viewModel.isExpiringSoon
        )

        if viewModel.isExpiringSoon {
            codeLabel.textColor = DS.Color.error
            accentStripe.backgroundColor = DS.Color.error
        } else {
            codeLabel.textColor = DS.Color.accent
            accentStripe.backgroundColor = DS.Color.accent
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
        codeLabel.text = nil
        codeLabel.textColor = DS.Color.accent
        accentStripe.backgroundColor = DS.Color.accent
        circularProgress.resetAppearance()
        onCopyTapped = nil
    }
}
