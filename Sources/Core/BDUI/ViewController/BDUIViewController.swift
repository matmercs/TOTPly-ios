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
    private let loader: BDUILoader
    private let differ = BDUITreeDiffer()
    private var currentNode: BDUINode?
    private var currentView: UIView?
    private var config: BDUIScreenConfig?

    private lazy var stateView = DSStateView()

    var onNavigate: ((String) -> Void)? {
        get { actionHandler.onNavigate }
        set { actionHandler.onNavigate = newValue }
    }

    init(loader: BDUILoader = BDUILoaderImpl()) {
        let registry = BDUIMapperRegistry.makeDefault()
        registry.logger = ConsoleBDUILogger()

        let actionHandler = BDUIActionHandlerImpl()
        actionHandler.logger = registry.logger

        self.renderer = BDUINodeRendererImpl(registry: registry, actionHandler: actionHandler)
        self.actionHandler = actionHandler
        self.loader = loader

        super.init(nibName: nil, bundle: nil)

        actionHandler.viewController = self
        actionHandler.onReload = { [weak self] in
            self?.reload()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DS.Color.background
        setupStateView()
    }

    func loadFromConfig(_ config: BDUIScreenConfig) {
        self.config = config
        if let title = config.title {
            self.title = title
        }
        loadFromEndpoint(config.endpoint)
    }

    func loadJSONFromBundle(named fileName: String) {
        do {
            let node = try loader.loadFromBundle(named: fileName)
            stateView.setState(.content)
            renderNode(node)
        } catch {
            showError(error.localizedDescription)
        }
    }

    private func setupStateView() {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stateView)
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        stateView.onRetryTapped = { [weak self] in
            self?.reload()
        }
    }

    private func loadFromEndpoint(_ endpoint: String) {
        stateView.setState(.loading(message: nil))
        currentView?.isHidden = true

        Task { @MainActor in
            do {
                let node = try await loader.loadFromEndpoint(endpoint)
                print("[BDUI] Loaded from server: \(endpoint)")
                stateView.setState(.content)
                renderNode(node)
                currentView?.isHidden = false
            } catch {
                if let fallback = config?.fallbackBundleName {
                    print("[BDUI] Server failed, using fallback bundle: \(fallback)")
                    loadJSONFromBundle(named: fallback)
                    currentView?.isHidden = false
                } else {
                    showError("Не удалось загрузить: \(error.localizedDescription)")
                }
            }
        }
    }

    private func reload() {
        if let config {
            loadFromEndpoint(config.endpoint)
        } else if let node = currentNode {
            renderNode(node)
        }
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
        view.insertSubview(newView, belowSubview: stateView)
        newView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func showError(_ message: String) {
        stateView.setState(.error(message: message, retryTitle: "Повторить"))
        currentView?.isHidden = true
    }
}
