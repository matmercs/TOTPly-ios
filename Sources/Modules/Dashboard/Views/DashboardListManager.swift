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
        let oldIds = self.items.map(\.id)
        let newIds = items.map(\.id)
        self.items = items

        if oldIds == newIds {
            for cell in tableView.visibleCells {
                guard let indexPath = tableView.indexPath(for: cell),
                      let totpCell = cell as? TOTPCell,
                      indexPath.row < items.count else { continue }
                totpCell.configure(with: items[indexPath.row])
            }
        } else {
            tableView.reloadData()
        }
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

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.onItemDeleted?(item.id)
            completion(true)
        }

        let cell = tableView.cellForRow(at: indexPath)
        let cellHeight = cell?.contentView.frame.height ?? DS.Size.estimatedCellHeight
        deleteAction.image = Self.makeDeleteActionImage(height: cellHeight)
        deleteAction.backgroundColor = DS.Color.background

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }

    // Рисуем свою карточку для действия удаления
    private static func makeDeleteActionImage(height: CGFloat) -> UIImage? {
        let width: CGFloat = 64
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { _ in
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: DS.CornerRadius.medium)
            DS.Color.error.setFill()
            path.fill()

            if let icon = DS.Icon.image(DS.Icon.delete, size: .medium, tint: .white) {
                let iconOrigin = CGPoint(
                    x: (size.width - icon.size.width) / 2,
                    y: (size.height - icon.size.height) / 2
                )
                icon.draw(at: iconOrigin)
            }
        }
    }
}
