//
//  CoinLogo.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

struct CoinLogo: View {
  let coin: CoinModel

  var body: some View {
    VStack {
      CoinImageView(coin: coin)
        .frame(width: 44, height: 44)

      if let symbol = coin.symbol {
        Text(symbol.uppercased())
          .font(.headline)
          .foregroundStyle(Color.theme.accentClr)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
      }

      if let name = coin.name {
        Text(name)
          .font(.caption)
          .foregroundStyle(Color.theme.accentClr)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .minimumScaleFactor(0.5)
      }
    }
  }
}

struct CoinLogo_Previews: PreviewProvider {
  static var previews: some View {
    CoinLogo(coin: dev.coin)
  }
}
