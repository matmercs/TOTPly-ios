//
//  BDUIViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 06.04.2026.
//

import UIKit

final class BDUIViewController: UIViewController {
    private let renderer: BDUINodeRendererImpl
    private let actionHandler: BDUIActionHandlerImpl
    private let differ = BDUITreeDiffer()
    private var currentNode: BDUINode?
    private var currentView: UIView?

    var onNavigate: ((String) -> Void)? {
        get { actionHandler.onNavigate }
        set { actionHandler.onNavigate = newValue }
    }

    init() {
        let registry = BDUIMapperRegistry.makeDefault()
        registry.logger = ConsoleBDUILogger()

        let actionHandler = BDUIActionHandlerImpl()
        actionHandler.logger = registry.logger

        self.renderer = BDUINodeRendererImpl(registry: registry, actionHandler: actionHandler)
        self.actionHandler = actionHandler

        super.init(nibName: nil, bundle: nil)

        actionHandler.viewController = self
        actionHandler.onReload = { [weak self] in
            guard let self, let node = self.currentNode else { return }
            self.renderNode(node)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
    }

    func loadJSON(_ data: Data) {
        do {
            let node = try JSONDecoder().decode(BDUINode.self, from: data)
            renderNode(node)
        } catch {
            showError("Failed to decode JSON: \(error.localizedDescription)")
        }
    }

    func loadJSONFromBundle(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            showError("JSON file '\(fileName).json' not found in bundle")
            return
        }
        loadJSON(data)
    }

    private func renderNode(_ node: BDUINode) {
        if let oldNode = currentNode, let oldView = currentView {
            let updatedView = differ.update(
                oldNode: oldNode,
                newNode: node,
                existingView: oldView,
                renderer: renderer
            )
            if updatedView !== oldView {
                replaceContent(with: updatedView)
            }
        } else {
            let newView = renderer.render(node: node)
            replaceContent(with: newView)
        }
        currentNode = node
    }

    private func replaceContent(with newView: UIView) {
        currentView?.removeFromSuperview()
        currentView = newView
        view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func showError(_ message: String) {
        let label = UILabel()
        label.text = message
        label.apply(.body)
        label.textColor = DS.Color.error
        label.textAlignment = .center
        label.numberOfLines = 0
        replaceContent(with: label)
    }
}
