//
//  BDUIActionHandlerImpl.swift
//  TOTPly-ios
//
//  Created by Matthew on 05.04.2026.
//

import UIKit

final class BDUIActionHandlerImpl: BDUIActionHandler {
    weak var viewController: UIViewController?
    var onReload: (() -> Void)?
    var logger: BDUILogger?
    var networkClient: NetworkClient?

    func attach(action: BDUIAction, to view: UIView) {
        let wrapper = ActionWrapper(action: action, handler: self)
        objc_setAssociatedObject(view, &ActionWrapper.key, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        if let button = view as? UIButton {
            button.addTarget(wrapper, action: #selector(ActionWrapper.performAction), for: .touchUpInside)
        } else {
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: wrapper, action: #selector(ActionWrapper.performAction))
            view.addGestureRecognizer(tap)
        }
    }

    func execute(action: BDUIAction) {
        switch action.type {
        case .print:
            let message = action.payload?.stringValue ?? "No message"
            Swift.print("[BDUI Action] \(message)")

        case .open:
            guard let urlString = action.payload?.stringValue,
                  let url = URL(string: urlString) else { return }
            UIApplication.shared.open(url)

        case .alert:
            guard let payload = action.payload?.objectValue else { return }
            let title = payload["title"]?.stringValue ?? ""
            let message = payload["message"]?.stringValue ?? ""
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(alert, animated: true)

        case .reload:
            onReload?()

        case .http:
            executeHTTPAction(action)
        }
    }

    private func executeHTTPAction(_ action: BDUIAction) {
        guard let payload = action.payload?.objectValue,
              let urlString = payload["url"]?.stringValue,
              let url = URL(string: urlString) else { return }

        let client = networkClient ?? URLSessionNetworkClient()
        let headers = payload["headers"]?.objectValue?.compactMapValues { $0.stringValue } ?? [:]

        Task { @MainActor in
            do {
                let _: JSONValue = try await client.get(url, headers: headers)

                if let onSuccess = payload["onSuccess"],
                   let successAction = try? onSuccess.decode(BDUIAction.self) {
                    execute(action: successAction)
                }
            } catch {
                executeOnError(from: payload)
                logger?.report(
                    event: "bdui.http_action_error",
                    params: ["url": urlString, "error": error.localizedDescription]
                )
            }
        }
    }

    private func executeOnError(from payload: [String: JSONValue]) {
        if let onError = payload["onError"],
           let errorAction = try? onError.decode(BDUIAction.self) {
            execute(action: errorAction)
        }
    }
}

private final class ActionWrapper: NSObject {
    static var key = 0

    let action: BDUIAction
    weak var handler: BDUIActionHandlerImpl?

    init(action: BDUIAction, handler: BDUIActionHandlerImpl) {
        self.action = action
        self.handler = handler
    }

    @objc func performAction() {
        handler?.execute(action: action)
    }
}
