//
//  RemoteTOTPRepository.swift
//  TOTPly-ios
//
//  Created by Matthew on 10.03.2026.
//

import Foundation

final class RemoteTOTPRepository: TOTPRepository {
    private let networkClient: NetworkClient
    private let storage: StorageService
    private let baseURL: String
    private let echoPath: String
    
    private let cacheTTL: TimeInterval = 30 * 60
    private var lastSyncDate: Date?
    
    init(
        networkClient: NetworkClient,
        storage: StorageService,
        baseURL: String = "https://alfaitmo.ru/server/echo",
        echoPath: String = "471057/totply-ios/items"
    ) {
        self.networkClient = networkClient
        self.storage = storage
        self.baseURL = baseURL
        self.echoPath = echoPath
    }
    
    private func saveItemsToLocalStorage(_ items: [TOTPItem]) throws {
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    
    func fetchRemoteItems() async throws -> [TOTPItem] {
        if let cachedItems = try? await fetchLocalItems(),
           !cachedItems.isEmpty,
           let lastSync = lastSyncDate,
           Date().timeIntervalSince(lastSync) < cacheTTL {
            return cachedItems
        }
        
        do {

            guard let url = URL(string: "\(baseURL)/\(echoPath)") else {
                throw NetworkError.invalidResponse
            }
            
            let response: TOTPItemsResponse = try await networkClient.get(url)
            
            // Маппим DTO в domain модели
            // Пока если хотя бы один элемент невалиден то бросим ошибку
            let items = try response.items.map { try $0.toDomain() }
            
            lastSyncDate = Date()
            
            try saveItemsToLocalStorage(items)
            
            return items
        } catch {
            // Graceful degradation: если сеть недоступна, используем устаревший кэш, с секретами это ок
            if let staleCachedItems = try? await fetchLocalItems(), !staleCachedItems.isEmpty {
                if let lastSync = lastSyncDate {
                    let cacheAge = Date().timeIntervalSince(lastSync)
                    print("Network error, using stale cache (age: \(Int(cacheAge))s)")
                } else {
                    print("Network error, using old cache (unknown age)")
                }
                return staleCachedItems
            }
            
            // а вот если кэша нет то грустно
            throw error
        }
    }
    
    func fetchLocalItems() async throws -> [TOTPItem] {
        // грузим из локального кейчейна
        guard let items: [TOTPItem] = try storage.load(key: StorageKey.totpItems.rawValue) else {
            return []
        }
        return items.filter { !$0.isDeleted }
    }
    
    func saveItem(_ item: TOTPItem) async throws {
        // Пока сохраняем только локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        } else {
            items.append(item)
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    func deleteItem(id: String) async throws {
        // Пока помечаем как удалённый локально
        var items = try await fetchLocalItems()
        if let index = items.firstIndex(where: { $0.id == id }) {
            let item = items[index]
            items[index] = TOTPItem(
                id: item.id,
                name: item.name,
                issuer: item.issuer,
                secret: item.secret,
                algorithm: item.algorithm,
                digits: item.digits,
                period: item.period,
                createdAt: item.createdAt,
                updatedAt: Date(),
                isDeleted: true,
                syncedAt: item.syncedAt
            )
        }
        try storage.save(items, key: StorageKey.totpItems.rawValue)
    }
    
    func invalidateCache() {
        lastSyncDate = nil
        
        // можно явно удалить?
    }
}
