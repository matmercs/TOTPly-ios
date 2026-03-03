//
//  DashboardViewState.swift
//  TOTPly-ios
//
//  Created by Matthew on 28.02.2026.
//

import Foundation

struct DashboardViewState: Equatable {
    var loadingState: LoadingState
    var items: [DashboardTOTPItem]
    var searchQuery: String
    var filteredItems: [DashboardTOTPItem]
    var isRefreshing: Bool
    var areCodesMasked: Bool

    static var initial: DashboardViewState {
        DashboardViewState(
            loadingState: .initial,
            items: [],
            searchQuery: "",
            filteredItems: [],
            isRefreshing: false,
            areCodesMasked: false
        )
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var displayItems: [DashboardTOTPItem] {
        searchQuery.isEmpty ? items : filteredItems
    }
}
