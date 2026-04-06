//
//  BDUIMapperRegistry.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import Foundation

final class BDUIMapperRegistry {
    private var mappers: [String: BDUINodeMapper] = [:]
    private let fallback: BDUINodeMapper = FallbackNodeMapper()
    var logger: BDUILogger?

    func register(_ mapper: BDUINodeMapper) {
        mappers[mapper.nodeType] = mapper
    }

    func mapper(for type: String) -> BDUINodeMapper {
        if let mapper = mappers[type] {
            return mapper
        }
        logger?.report(
            event: "bdui.unknown_node_type",
            params: ["type": type]
        )
        return fallback
    }

    static func makeDefault() -> BDUIMapperRegistry {
        let registry = BDUIMapperRegistry()
        registry.register(LabelNodeMapper())
        registry.register(ButtonNodeMapper())
        registry.register(StackNodeMapper(axis: .vertical))
        registry.register(StackNodeMapper(axis: .horizontal))
        registry.register(ContainerNodeMapper())
        registry.register(SpacerNodeMapper())
        registry.register(DividerNodeMapper())
        registry.register(CardNodeMapper())
        registry.register(IconNodeMapper())
        registry.register(TextFieldNodeMapper())
        registry.register(LoadingNodeMapper())
        registry.register(EmptyNodeMapper())
        registry.register(CircularProgressNodeMapper())
        registry.register(ScrollNodeMapper())
        return registry
    }
}
