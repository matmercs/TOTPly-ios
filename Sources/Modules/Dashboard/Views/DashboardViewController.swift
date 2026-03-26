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

        rootView.stateView.onRetryTapped = { [weak self] in
            self?.presenter?.didPullToRefresh()
        }

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
            image: DS.Icon.image(DS.Icon.refresh, size: .medium, tint: DS.Color.accent),
            style: .plain,
            target: self,
            action: #selector(didTapForceRefresh)
        )
        let maskButton = UIBarButtonItem(
            image: DS.Icon.image(DS.Icon.eyeClosed, size: .medium, tint: DS.Color.accent),
            style: .plain,
            target: self,
            action: #selector(didTapToggleMask)
        )
        navigationItem.rightBarButtonItems = [refreshButton, maskButton]

        let profileButton = UIBarButtonItem(
            image: DS.Icon.image(DS.Icon.profile, size: .medium, tint: DS.Color.accent),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
        let settingsButton = UIBarButtonItem(
            image: DS.Icon.image(DS.Icon.settings, size: .medium, tint: DS.Color.accent),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
        navigationItem.leftBarButtonItems = [profileButton, settingsButton]
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.font = TextStyle.body.font
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
            rootView.stateView.setState(.loading(message: nil))
            rootView.tableView.isHidden = true

        case .loaded:
            if isEmpty {
                rootView.stateView.setState(.empty(
                    icon: DS.Icon.empty,
                    title: "Нет TOTP-кодов",
                    subtitle: "Добавьте первый код"
                ))
                rootView.tableView.isHidden = true
            } else {
                rootView.stateView.setState(.content)
                rootView.tableView.isHidden = false
            }

        case .error(let error):
            rootView.stateView.setState(.error(
                message: error.localizedDescription,
                retryTitle: "Повторить"
            ))
            rootView.tableView.isHidden = true
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
            let iconName = state.areCodesMasked ? DS.Icon.eyeOpen : DS.Icon.eyeClosed
            maskButton.image = DS.Icon.image(iconName, size: .medium, tint: DS.Color.accent)
        }
    }

    func copyCodeToClipboard(_ code: String) {
        UIPasteboard.general.string = code
        showCopiedToast()
    }

    private func showCopiedToast() {
        let toast = UILabel()
        toast.text = "Скопировано"
        toast.font = TextStyle.subheadline.font
        toast.textColor = DS.Color.toastText
        toast.backgroundColor = DS.Color.toastBackground
        toast.textAlignment = .center
        toast.layer.cornerRadius = DS.CornerRadius.large
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0

        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: DS.Size.Toast.bottomOffset),
            toast.widthAnchor.constraint(equalToConstant: DS.Size.Toast.width),
            toast.heightAnchor.constraint(equalToConstant: DS.Size.Toast.height),
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
