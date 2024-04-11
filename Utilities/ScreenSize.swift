//
//  ScreenSize.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

final class ScreenSize {
  static let instance = ScreenSize()
  private init() {}

  func getWidth() -> CGFloat {
    if let w = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      return w.screen.bounds.width
    } else {
      return 1.0
    }
  }

  func getHeight() -> CGFloat {
    if let w = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      return w.screen.bounds.height
    } else {
      return 1.0
    }
  }

}
