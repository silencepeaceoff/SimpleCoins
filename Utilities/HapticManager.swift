//
//  HapticManager.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 04.04.2024.
//

import SwiftUI

final class HapticManager {
  static private let generator = UINotificationFeedbackGenerator()

  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
