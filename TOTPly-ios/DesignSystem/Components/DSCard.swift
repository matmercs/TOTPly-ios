//
//  DSCard.swift
//  TOTPly-ios
//
//  Created by Matthew on 25.03.2026.
//

import UIKit

final class DSCard: UIView {
    private(set) lazy var cardContent: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true // чтобы stripe правильно обрезался по углам
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = DS.Color.surfaceCard
        layer.cornerRadius = DS.CornerRadius.medium
        clipsToBounds = false // чтобы тень не обрезалась
        applyShadow(DS.Shadow.card)

        cardContent.backgroundColor = .clear
        cardContent.layer.cornerRadius = DS.CornerRadius.medium
        addSubview(cardContent)

        NSLayoutConstraint.activate([
            cardContent.topAnchor.constraint(equalTo: topAnchor),
            cardContent.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContent.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardContent.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: DS.CornerRadius.medium
        ).cgPath
    }
}
