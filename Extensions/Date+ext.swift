//
//  Date+ext.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

import Foundation

extension Date {

  // "2024-04-01T13:57:21.067Z"
  init(dateString: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    let date = dateFormatter.date(from: dateString) ?? Date()
    self.init(timeInterval: 0, since: date)
  }

  private var shortFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }

  func asString() -> String {
    shortFormatter.string(from: self)
  }
}
