//
//  DSTextField.swift
//  TOTPly-ios
//
//  Created by Matthew on 24.03.2026.
//

import UIKit

final class DSTextField: UIView {

    struct Configuration {
        var placeholder: String = ""
        var isSecure: Bool = false
        var keyboardType: UIKeyboardType = .default
        var autocapitalizationType: UITextAutocapitalizationType = .sentences
        var returnKeyType: UIReturnKeyType = .default
        var accessibilityId: String?
        var onTextChanged: ((String) -> Void)?
        var onEditingDidEnd: (() -> Void)?
        var onReturnTapped: (() -> Void)?
    }

    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    private(set) var onTextChanged: ((String) -> Void)?
    private(set) var onEditingDidEnd: (() -> Void)?
    private(set) var onReturnTapped: (() -> Void)?

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.apply(.footnote)
        l.textColor = DS.Color.textSecondary
        l.isHidden = true
        return l
    }()

    private lazy var textField: UITextField = {
        let t = UITextField()
        t.font = TextStyle.body.font
        t.textColor = DS.Color.textPrimary
        t.backgroundColor = DS.Color.fieldBackground
        t.layer.cornerRadius = DS.CornerRadius.small
        t.layer.borderWidth = DS.Size.Field.borderWidth
        t.layer.borderColor = DS.Color.fieldBorder.cgColor
        t.autocorrectionType = .no
        t.translatesAutoresizingMaskIntoConstraints = false

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 0))
        t.leftView = paddingView
        t.leftViewMode = .always
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 0))
        t.rightView = rightPadding
        t.rightViewMode = .always

        return t
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption)
        l.textColor = DS.Color.error
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = DS.Spacing.xs
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    init(configuration: Configuration = Configuration()) {
        self.onTextChanged = configuration.onTextChanged
        self.onEditingDidEnd = configuration.onEditingDidEnd
        self.onReturnTapped = configuration.onReturnTapped
        super.init(frame: .zero)
        textField.keyboardType = configuration.keyboardType
        textField.autocapitalizationType = configuration.autocapitalizationType
        textField.returnKeyType = configuration.returnKeyType
        textField.accessibilityIdentifier = configuration.accessibilityId
        textField.placeholder = configuration.placeholder
        textField.isSecureTextEntry = configuration.isSecure
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(errorLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: DS.Size.Field.height),
        ])

        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.delegate = self
        registerForTraitChanges()
    }

    func configure(title: String?, placeholder: String, error: String?, isSecure: Bool) {
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure

        if let error = error {
            errorLabel.text = error
            errorLabel.isHidden = false
            textField.layer.borderColor = DS.Color.error.cgColor
        } else {
            errorLabel.isHidden = true
            textField.layer.borderColor = DS.Color.fieldBorder.cgColor
        }
    }

    func setEnabled(_ enabled: Bool) {
        textField.isUserInteractionEnabled = enabled
        alpha = enabled ? 1.0 : 0.5
    }
    
    @discardableResult // без этого xcode ругается на unused результат
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        textField.isFirstResponder
    }

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }

    private func registerForTraitChanges() {
        // так как layer.borderColor принимает статический CGColor
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: DSTextField, _: UITraitCollection) in
            let hasError = !view.errorLabel.isHidden
            view.textField.layer.borderColor = hasError ? DS.Color.error.cgColor : DS.Color.fieldBorder.cgColor
        }
    }
}

extension DSTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let onReturnTapped = onReturnTapped {
            onReturnTapped()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        onEditingDidEnd?()
    }
}
