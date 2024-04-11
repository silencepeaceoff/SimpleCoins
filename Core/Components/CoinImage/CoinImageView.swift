//
//  CoinImageView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import SwiftUI

struct CoinImageView: View {
  @StateObject private var vm: CoinImageViewModel

  init(coin: CoinModel) {
    _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
  }

  var body: some View {
    ZStack {
      if let image = vm.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else if vm.isLoading {
        ProgressView()
      } else {
        Image(systemName: "questionmark")
          .foregroundStyle(Color.theme.secondaryTextClr)
      }
    }
  }
}

struct CoinImageView_Previews: PreviewProvider {
  static var previews: some View {
    CoinImageView(coin: dev.coin)
      .padding()
  }
}
