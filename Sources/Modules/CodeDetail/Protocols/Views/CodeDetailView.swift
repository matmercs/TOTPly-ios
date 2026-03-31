//
//  CodeDetailView.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol CodeDetailView: AnyObject {
    func render(_ state: CodeDetailViewState)
    func copyCodeToClipboard(_ code: String)
    func showShareSheet(text: String)
    func showDeleteConfirmation(onConfirm: @escaping () -> Void)
}
