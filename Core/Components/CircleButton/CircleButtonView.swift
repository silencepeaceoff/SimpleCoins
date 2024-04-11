//
//  CircleButtonView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

struct CircleButtonView: View {
  let iconName: String

  var body: some View {
    Image(systemName: iconName)
      .font(.headline)
      .foregroundStyle(Color.theme.accentClr)
      .frame(width: 50, height: 50)
      .background(
        Circle()
          .foregroundStyle(Color.theme.backgroundClr)
      )
      .shadow(
        color: Color.theme.accentClr.opacity(0.25),
        radius: 10, x: 0, y: 0
      )
      .padding()
  }
}

struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CircleButtonView(iconName: "info")

      CircleButtonView(iconName: "plus")
        .preferredColorScheme(.dark)
    }
  }
}
