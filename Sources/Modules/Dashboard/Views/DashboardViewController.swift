//
//  DashboardViewController.swift
//  TOTPly-ios
//
//  Created by Matthew on 17.03.2026.
//

import UIKit

final class DashboardViewController: UIViewController {
    var presenter: DashboardPresenter?

    private var listManager: DashboardListManager?
    private var currentState: DashboardViewState?

    private var rootView: DashboardRootView { view as! DashboardRootView }

    override func loadView() {
        view = DashboardRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"

        setupNavigationBar()
        setupSearchController()
        setupRefreshControl()

        rootView.retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        listManager = DashboardListManager(tableView: rootView.tableView)
        listManager?.onItemSelected = { [weak self] index in
            self?.presenter?.didTapItem(at: index)
        }
        listManager?.onItemDeleted = { [weak self] itemId in
            self?.presenter?.didTapDelete(itemId: itemId)
        }
        listManager?.onItemCopyCode = { [weak self] itemId in
            self?.presenter?.didTapCopyCode(itemId: itemId)
        }

        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapForceRefresh)
        )
        let maskButton = UIBarButtonItem(
            image: UIImage(systemName: "eye.slash"),
            style: .plain,
            target: self,
            action: #selector(didTapToggleMask)
        )
        navigationItem.rightBarButtonItems = [refreshButton, maskButton]

        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(didTapProfile))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettings))
        navigationItem.leftBarButtonItems = [profileButton, settingsButton]
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        rootView.tableView.refreshControl = refreshControl
    }

    private func applyState(_ loadingState: LoadingState, isEmpty: Bool) {
        switch loadingState {
        case .initial, .loading:
            rootView.activityIndicator.startAnimating()
            rootView.tableView.isHidden = true
            rootView.emptyLabel.isHidden = true
            rootView.errorView.isHidden = true

        case .loaded:
            rootView.activityIndicator.stopAnimating()
            if isEmpty {
                rootView.tableView.isHidden = true
                rootView.emptyLabel.isHidden = false
            } else {
                rootView.tableView.isHidden = false
                rootView.emptyLabel.isHidden = true
            }
            rootView.errorView.isHidden = true

        case .error(let error):
            rootView.activityIndicator.stopAnimating()
            rootView.tableView.isHidden = true
            rootView.emptyLabel.isHidden = true
            rootView.errorView.isHidden = false
            rootView.errorLabel.text = error.localizedDescription
        }
    }

    @objc private func didTapProfile() {
        presenter?.didTapProfile()
    }

    @objc private func didTapSettings() {
        presenter?.didTapSettings()
    }

    @objc private func didTapToggleMask() {
        presenter?.didTapToggleCodeMask()
    }

    @objc private func didTapForceRefresh() {
        presenter?.didTapForceRefresh()
    }

    @objc private func didTapRetry() {
        presenter?.didPullToRefresh()
    }

    @objc private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }
}

extension DashboardViewController: DashboardView {
    func render(_ state: DashboardViewState) {
        currentState = state

        let cellViewModels = state.displayItems.map {
            TOTPCellModel.from(item: $0, masked: state.areCodesMasked)
        }

        listManager?.update(items: cellViewModels)
        applyState(state.loadingState, isEmpty: state.displayItems.isEmpty)

        if !state.isRefreshing {
            rootView.tableView.refreshControl?.endRefreshing()
        }

        if let maskButton = navigationItem.rightBarButtonItems?.last {
            let iconName = state.areCodesMasked ? "eye" : "eye.slash"
            maskButton.image = UIImage(systemName: iconName)
        }
    }

    func copyCodeToClipboard(_ code: String) {
        UIPasteboard.general.string = code
        showCopiedToast()
    }

    private func showCopiedToast() {
        let toast = UILabel()
        toast.text = "Скопировано"
        toast.font = .systemFont(ofSize: 14, weight: .medium)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toast.textAlignment = .center
        toast.layer.cornerRadius = 16
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0

        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toast.widthAnchor.constraint(equalToConstant: 140),
            toast.heightAnchor.constraint(equalToConstant: 32),
        ])

        UIView.animate(withDuration: 0.2, animations: {
            toast.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.8, options: [], animations: {
                toast.alpha = 0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
}

extension DashboardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        presenter?.didSearch(query: query)
    }
}
