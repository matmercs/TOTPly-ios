//
//  AddTOTPView.swift
//  TOTPly-ios
//
//  Created by Matthew on 01.03.2026.
//

import Foundation

protocol AddTOTPView: AnyObject {
    func render(_ state: AddTOTPViewState)
    
    // нужен чтобы после парсинга QR проставить текст в поля (render их не затирает при перерисовке state)
    func fillFields(name: String, issuer: String, secret: String)
}
