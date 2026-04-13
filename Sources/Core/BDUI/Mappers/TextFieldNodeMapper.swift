//
//  TextFieldNodeMapper.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class TextFieldNodeMapper: BDUINodeMapper {
    let nodeType = "textField"

    private struct Content: Codable {
        let placeholder: String?
        let title: String?
        let isSecure: Bool?
        let keyboardType: String?
    }

    func makeView(from node: BDUINode, renderer: BDUINodeRenderer, actionHandler: BDUIActionHandler) -> UIView {
        let config = try? node.content?.decode(Content.self)

        let keyboardType: UIKeyboardType = {
            switch config?.keyboardType {
            case "email":   return .emailAddress
            case "number":  return .numberPad
            case "phone":   return .phonePad
            case "url":     return .URL
            default:        return .default
            }
        }()

        let textField = DSTextField(configuration: .init(
            placeholder: config?.placeholder ?? "",
            isSecure: config?.isSecure ?? false,
            keyboardType: keyboardType
        ))

        if let title = config?.title {
            textField.configure(
                title: title,
                placeholder: config?.placeholder ?? "",
                error: nil,
                isSecure: config?.isSecure ?? false
            )
        }

        return textField
    }
}
