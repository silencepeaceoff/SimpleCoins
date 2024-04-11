//
//  View+ext.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 04.04.2024.
//

import SwiftUI

extension View {
  func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}
