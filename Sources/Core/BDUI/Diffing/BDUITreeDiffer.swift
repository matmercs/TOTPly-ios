//
//  BDUITreeDiffer.swift
//  TOTPly-ios
//
//  Created by Matthew on 06.04.2026.
//

import UIKit

final class BDUITreeDiffer {

    func update(
        oldNode: BDUINode,
        newNode: BDUINode,
        existingView: UIView,
        renderer: BDUINodeRenderer
    ) -> UIView {
        guard oldNode.id == newNode.id, oldNode.type == newNode.type else {
            return renderer.render(node: newNode)
        }

        if oldNode == newNode {
            return existingView
        }

        // Пробуем перерендерить только изменившихся детей (если они есть)
        if let oldChildren = oldNode.subviews,
           let newChildren = newNode.subviews,
           let stackView = findStackView(in: existingView) {
            applyChildDiff(
                old: oldChildren,
                new: newChildren,
                stackView: stackView,
                renderer: renderer
            )
            return existingView
        }

        return renderer.render(node: newNode)
    }

    private func findStackView(in view: UIView) -> UIStackView? {
        if let stack = view as? UIStackView { return stack }
        
        // scroll > contentStack и card > cardContent > innerStack
        for subview in view.subviews {
            if let stack = subview as? UIStackView { return stack }
            for inner in subview.subviews {
                if let stack = inner as? UIStackView { return stack }
            }
        }
        return nil
    }

    private func applyChildDiff(
        old: [BDUINode],
        new: [BDUINode],
        stackView: UIStackView,
        renderer: BDUINodeRenderer
    ) {
        let oldMap = Dictionary(uniqueKeysWithValues: old.enumerated().map { ($1.id, $0) })
        let existingViews = stackView.arrangedSubviews

        // Проходим по старым детям в обратном порядке и удаляем тех чьих id нет в новом списке
        // В обратном чтобы индексы не сбивались при удалении
        let newIds = Set(new.map(\.id))
        for (index, oldChild) in old.enumerated().reversed() {
            if !newIds.contains(oldChild.id), index < existingViews.count {
                let view = existingViews[index]
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        for (newIndex, newChild) in new.enumerated() {
            if let oldIndex = oldMap[newChild.id], oldIndex < existingViews.count {
                let oldChild = old[oldIndex]
                if oldChild != newChild {
                    // Нода с таким id была раньше, но content изменился
                    let oldView = existingViews[oldIndex]
                    let newView = renderer.render(node: newChild)
                    stackView.removeArrangedSubview(oldView)
                    oldView.removeFromSuperview()
                    stackView.insertArrangedSubview(newView, at: min(newIndex, stackView.arrangedSubviews.count))
                }
            } else {
                let newView = renderer.render(node: newChild)
                stackView.insertArrangedSubview(newView, at: min(newIndex, stackView.arrangedSubviews.count))
            }
        }
    }
}
