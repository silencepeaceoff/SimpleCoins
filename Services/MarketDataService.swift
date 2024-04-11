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
    guard let url = URL(
      string: "https://api.coingecko.com/api/v3/global?&x_cg_demo_api_key=CG-CGhw4JokFzv2P6kbQtCbKkuK"
    ) else { return }

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
