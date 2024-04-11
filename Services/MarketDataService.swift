//
//  MarketDataService.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import Foundation
import Combine

final class MarketDataService {
  @Published private(set) var marketData: MarketData? = nil

  var marketDataSubscription: AnyCancellable?

  //MARK: - Init

  init() {
    getMarketData()
  }

  func getMarketData() {
    guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
          let config = NSDictionary(contentsOfFile: configPath),
          let apiKey = config["API_KEY"] as? String else {

      print("API key not found in configuration file")
      return
    }

    guard let url = URL(
      string: "https://api.coingecko.com/api/v3/global?\(apiKey)"
    ) else {
      print("URL error")
      return
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    marketDataSubscription = NetworkingManager.download(url: url)
      .decode(type: MarketData.self, decoder: decoder)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handle, receiveValue: { [weak self] returnedMarketData in
        guard let self else { return }
        self.marketData = returnedMarketData
        self.marketDataSubscription?.cancel()
      })
  }
}
