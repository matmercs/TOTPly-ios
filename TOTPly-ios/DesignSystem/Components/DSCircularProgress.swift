//
//  DSCircularProgress.swift
//  TOTPly-ios
//
//  Created by Matthew on 25.03.2026.
//

import UIKit

final class DSCircularProgress: UIView {
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let lineWidth: CGFloat = DS.Size.circularTimerLineWidth

    private lazy var timerLabel: UILabel = {
        let l = UILabel()
        l.font = DSFonts.medium(DS.Size.circularTimerFontSize)
        l.textColor = DS.Color.textSecondary
        l.textAlignment = .center
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
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = DS.Color.progressTrack.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = DS.Color.accent.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1.0
        layer.addSublayer(progressLayer)

        addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        registerForTraitChanges()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }

    func configure(progress: Double, timeText: String, isExpiring: Bool) {
        progressLayer.strokeEnd = CGFloat(progress)
        timerLabel.text = timeText

        let color = isExpiring ? DS.Color.error : DS.Color.accent
        progressLayer.strokeColor = color.cgColor
        timerLabel.textColor = color
    }

    func resetAppearance() {
        progressLayer.strokeEnd = 1.0
        progressLayer.strokeColor = DS.Color.accent.cgColor
        timerLabel.text = nil
        timerLabel.textColor = DS.Color.textSecondary
    }

    private func registerForTraitChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: DSCircularProgress, _: UITraitCollection) in
            view.trackLayer.strokeColor = DS.Color.progressTrack.cgColor
        }
    }
}
