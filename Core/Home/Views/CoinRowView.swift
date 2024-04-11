//
//  CoinRowView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

struct CoinRowView: View {
  let coin: CoinModel
  let showHoldingsColumn: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      leftColumn
      
      Spacer()
      
      if showHoldingsColumn {
        centerColumn
      }
      
      rightColumn
    }
    .font(.subheadline)
    .background(
      Color.theme.backgroundClr
    )

  }
}

extension CoinRowView {
  private var leftColumn: some View {
    
    HStack(spacing: 0) {
      
      Text("\(coin.rank)")
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextClr)
        .frame(minWidth: 30)
      
      CoinImageView(coin: coin)
        .scaledToFit()
        .frame(width: 30, height: 30)
      
      if let symbol = coin.symbol {
        Text(symbol.uppercased())
          .font(.headline)
          .padding(.leading, 6)
          .foregroundStyle(Color.theme.accentClr)
      }
    }
  }
  
  private var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue, format: .currency(code: "usd"))
        .bold()
      
      if let currentHoldings = coin.currentHoldings {
        Text(currentHoldings, format: .number.precision(.fractionLength(2)))
      }
    }
    .foregroundStyle(Color.theme.accentClr)
  }
  
  private var rightColumn: some View {
    VStack(alignment: .trailing) {
      if let currentPrice = coin.currentPrice {
        Text(currentPrice, format: .currency(code: "usd"))
          .bold()
          .foregroundStyle(Color.theme.accentClr)
      }
      
      if let priceChangePercentage24H = coin.priceChangePercentage24H {
        Text(priceChangePercentage24H / 100, format: .percent.precision(.fractionLength(2)))
          .bold()
          .foregroundStyle(
            priceChangePercentage24H >= 0 ? Color.theme.greenClr : Color.theme.redClr
          )
      }
    }
    .frame(width: ScreenSize.instance.getWidth() / 3.5, alignment: .trailing)
    
  }
}

struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    CoinRowView(coin: dev.coin, showHoldingsColumn: true)
  }
}
