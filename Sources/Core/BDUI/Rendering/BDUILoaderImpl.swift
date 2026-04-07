//
//  BDUILoaderImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 07.04.2026.
//

import Foundation

final class BDUILoaderImpl: BDUILoader {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = URLSessionNetworkClient()) {
        self.networkClient = networkClient
    }

    func loadFromEndpoint(_ endpoint: String) async throws -> BDUINode {
        guard let url = URL(string: endpoint) else {
            throw BDUILoaderError.invalidURL(endpoint)
        }
        return try await networkClient.get(url)
    }

    func loadFromBundle(named fileName: String) throws -> BDUINode {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw BDUILoaderError.fileNotFound(fileName)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(BDUINode.self, from: data)
    }
}

enum BDUILoaderError: LocalizedError {
    case invalidURL(String)
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let url): return "Некорректный URL: \(url)"
        case .fileNotFound(let name): return "Файл '\(name).json' не найден"
        }
    }
}

