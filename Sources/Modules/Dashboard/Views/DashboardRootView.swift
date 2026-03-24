//
//  DashboardRootView.swift
//  TOTPly-ios
//
//  Created by Matthew on 20.03.2026.
//

import UIKit

final class DashboardRootView: UIView {
    private(set) lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = DS.Size.estimatedCellHeight
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()

    private(set) lazy var stateView = DSStateView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = DS.Color.background
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        stateView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(stateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        stateView.isHidden = true
    }
}
