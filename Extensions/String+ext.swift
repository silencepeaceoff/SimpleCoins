//
//  String+ext.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 08.04.2024.
//

import UIKit

extension String {
  var removingHtml: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}
