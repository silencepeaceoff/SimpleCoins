//
//  CoinDataService.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import Foundation
import Combine

final class CoinDataService {
  @Published private(set) var allCoins: [CoinModel] = []
  var coinSubscription: AnyCancellable?

  //MARK: - Init

  init() {
    getCoins()
  }

  func getCoins() {
    guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
          let config = NSDictionary(contentsOfFile: configPath),
          let apiKey = config["API_KEY"] as? String else {

      print("API key not found in configuration file")
      return
    }

    guard let url = URL(string: """
                        https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc
                        &per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en\(apiKey)
                        """) else {

      print("URL error")
      return
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    coinSubscription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: decoder)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handle, receiveValue: { [weak self] returnedCoins in
        guard let self else { return }
        self.allCoins = returnedCoins
        self.coinSubscription?.cancel()
      })
  }
}
