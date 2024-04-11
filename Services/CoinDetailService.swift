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
    guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
          let config = NSDictionary(contentsOfFile: configPath),
          let apiKey = config["API_KEY"] as? String else {

      print("API key not found in configuration file")
      return
    }

    guard let coidID = coin.id,
          let url = URL(string: """
                        https://api.coingecko.com/api/v3/coins/\(coidID)?localization=false&tickers=false
                        &market_data=false&community_data=false&developer_data=false&sparkline=false\(apiKey)
                        """) else {

      print("URL error")
      return
    }

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
