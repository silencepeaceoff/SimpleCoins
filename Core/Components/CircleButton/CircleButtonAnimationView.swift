//
//  CircleButtonAnimationView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
  @Binding var animate: Bool

  var body: some View {
    Circle()
      .stroke(lineWidth: 5.0)
      .animation(animate ? .easeOut(duration: 1.0) : nil, body: { content in
        content
          .scaleEffect(animate ? 1.0 : 0.0)
          .opacity(animate ? 0.0 : 1.0)
      })
  }
}

#Preview {
  CircleButtonAnimationView(animate: .constant(false))
    .frame(width: 100, height: 100)
}
