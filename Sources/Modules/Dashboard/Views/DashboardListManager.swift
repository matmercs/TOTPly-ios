//
//  DashboardListManager.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class DashboardListManager: NSObject {
    private let tableView: UITableView
    private var items: [TOTPCellModel] = []

    var onItemSelected: ((Int) -> Void)?
    var onItemDeleted: ((String) -> Void)?
    var onItemCopyCode: ((String) -> Void)?

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        tableView.register(TOTPCell.self, forCellReuseIdentifier: TOTPCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

    }

    func update(items: [TOTPCellModel]) {
        self.items = items
        tableView.reloadData()
    }
}

extension DashboardListManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TOTPCell.reuseIdentifier,
            for: indexPath
        ) as? TOTPCell else {
            return UITableViewCell() // просто фоллбэк
        }

        let item = items[indexPath.row]
        cell.configure(with: item)
        cell.onCopyTapped = { [weak self] in
            self?.onItemCopyCode?(item.id)
        }
        return cell
    }
}

extension DashboardListManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onItemSelected?(indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let item = items[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            self?.onItemDeleted?(item.id)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
