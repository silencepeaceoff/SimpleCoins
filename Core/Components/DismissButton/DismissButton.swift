//
//  DismissButton.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

struct DismissButton: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
        .foregroundStyle(Color.theme.accentClr)
    }
  }
}

#Preview {
  DismissButton()
}
