//
//  DSStateView.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

enum DSViewState {
    case loading(message: String?)
    case error(message: String, retryTitle: String?)
    case empty(icon: String?, title: String, subtitle: String?)
    case content
}

final class DSStateView: UIView {
    var onRetryTapped: (() -> Void)? {
        didSet { errorView.onRetryTapped = onRetryTapped }
    }

    private lazy var loadingView = DSLoadingView()
    private lazy var errorView = DSErrorView()
    private lazy var emptyView = DSEmptyView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = DS.Color.background

        for subview in [loadingView, errorView, emptyView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
            subview.isHidden = true
        }
    }

    func setState(_ state: DSViewState) {
        loadingView.isHidden = true
        errorView.isHidden = true
        emptyView.isHidden = true

        switch state {
        case .loading(let message):
            isHidden = false
            loadingView.isHidden = false
            loadingView.configure(message: message)

        case .error(let message, let retryTitle):
            isHidden = false
            errorView.isHidden = false
            errorView.configure(message: message, retryTitle: retryTitle)

        case .empty(let icon, let title, let subtitle):
            isHidden = false
            emptyView.isHidden = false
            emptyView.configure(icon: icon, title: title, subtitle: subtitle)

        case .content:
            isHidden = true
        }
    }
}
