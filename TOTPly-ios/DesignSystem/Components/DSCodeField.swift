//
//  DSCodeField.swift
//  TOTPly-ios
//
//  Created by Matthew on 30.03.2026.
//

import UIKit

final class DSCodeField: UIView {
    var onCodeComplete: ((String) -> Void)?
    var onCodeChanged: ((String) -> Void)?

    private let length: Int
    private var cells: [UILabel] = []
    private let hiddenTextField = UITextField()

    var code: String {
        hiddenTextField.text ?? ""
    }

    init(length: Int = 6) {
        self.length = length
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        hiddenTextField.keyboardType = .numberPad
        hiddenTextField.textContentType = .oneTimeCode
        hiddenTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        hiddenTextField.alpha = 0
        addSubview(hiddenTextField)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = DS.Spacing.s
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        for _ in 0..<length {
            let cell = makeCell()
            cells.append(cell)
            stack.addArrangedSubview(cell)
        }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.heightAnchor.constraint(equalToConstant: DS.Size.CodeField.cellHeight),
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    private func makeCell() -> UILabel {
        let l = UILabel()
        l.textAlignment = .center
        l.font = TextStyle.code.font
        l.textColor = DS.Color.textPrimary
        l.backgroundColor = DS.Color.fieldBackground
        l.layer.cornerRadius = DS.CornerRadius.small
        l.layer.borderWidth = DS.Size.CodeField.borderWidth
        l.layer.borderColor = DS.Color.fieldBorder.cgColor
        l.clipsToBounds = true
        return l
    }

    @objc private func didTap() {
        hiddenTextField.becomeFirstResponder()
    }

    @objc private func textChanged() {
        let text = String((hiddenTextField.text ?? "").prefix(length))
        hiddenTextField.text = text

        for (i, cell) in cells.enumerated() {
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                cell.text = String(text[index])
                cell.layer.borderColor = DS.Color.accent.cgColor
            } else {
                cell.text = nil
                cell.layer.borderColor = DS.Color.fieldBorder.cgColor
            }
        }

        onCodeChanged?(text)

        if text.count == length {
            onCodeComplete?(text)
        }
    }

    func clear() {
        hiddenTextField.text = ""
        textChanged()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        hiddenTextField.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        hiddenTextField.resignFirstResponder()
    }
}
