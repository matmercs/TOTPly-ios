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

    var debugText: String {
        var text = "Dashboard State Debug\n\n"

        switch loadingState {
        case .initial:
            text += " State: Initial\n\n"
        case .loading:
            text += " State: Loading...\n\n"
        case .loaded:
            text += " State: Loaded\n\n"
        case .error(let error):
            text += " State: Error\n\(error.localizedDescription)\n\n"
        }

        text += " Количество items: \(items.count)\n"

        if !searchQuery.isEmpty {
            text += " Поиск: \"\(searchQuery)\"\n"
            text += " Фильтр: \(filteredItems.count)\n"
        }

        text += "\n"

        if items.isEmpty {
            text += "Нет данных\n"
        } else {
            for (index, item) in displayItems.enumerated() {
                text += "[\(index + 1)] \(item.displayName)\n"
                if let issuer = item.issuer {
                    text += "    Issuer: \(issuer)\n"
                }
                text += "    Code: \(areCodesMasked ? "••••••" : item.currentCode)\n"
                text += "    Expires in: \(item.timeRemaining)s\n"
                text += "\n"
            }
        }

        return text
    }
}
