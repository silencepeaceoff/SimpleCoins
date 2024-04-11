//
//  Color+ext.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let accentClr = Color("AccentClr")
  let backgroundClr = Color("BackgroundClr")
  let greenClr = Color("GreenClr")
  let redClr = Color("RedClr")
  let secondaryTextClr = Color("SecondaryTextClr")
}

struct ColorTheme2 {
  let accentClr = Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
  let backgroundClr = Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))
  let greenClr = Color(#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1))
  let redClr = Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
  let secondaryTextClr = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
}
