//
//  CoinDetailService.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

import Foundation
import Combine

final class CoinDetailService {
  @Published private(set) var coinDetails: CoinDetailModel? = nil

  private let coin: CoinModel

  private var coinDetailSubscription: AnyCancellable?

  //MARK: - Init

  init(coin: CoinModel) {
    self.coin = coin
    getCoinDetails()
  }

  func getCoinDetails() {
    guard let coidID = coin.id,
          let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coidID)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false&x_cg_demo_api_key=CG-CGhw4JokFzv2P6kbQtCbKkuK"
          ) else { return }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    coinDetailSubscription = NetworkingManager.download(url: url)
      .decode(type: CoinDetailModel.self, decoder: decoder)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handle, receiveValue: { [weak self] returnedCoinDetails in
        guard let self else { return }
        self.coinDetails = returnedCoinDetails
        self.coinDetailSubscription?.cancel()
      })
  }

}
