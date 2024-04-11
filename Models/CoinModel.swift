//
//  CoinModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import Foundation

struct CoinModel: Identifiable, Codable {
  let id, symbol, name: String?
  let image: String?
  let currentPrice: Double?
  let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Double?
  let high24H, low24H, priceChange24H, priceChangePercentage24H: Double?
  let marketCapChange24H, marketCapChangePercentage24H, circulatingSupply, totalSupply: Double?
  let maxSupply: Double?
  let ath, athChangePercentage: Double?
  let athDate: String?
  let atl, atlChangePercentage: Double?
  let sparklineIn7D: SparklineIn7D?
  let atlDate: String?
  let lastUpdated: String?
  let priceChangePercentage24HInCurrency: Double?

  let currentHoldings: Double?

  func updateHoldings(amount: Double) -> CoinModel {
    return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, sparklineIn7D: sparklineIn7D, atlDate: atlDate, lastUpdated: lastUpdated, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
  }

  var currentHoldingsValue: Double {
    (currentHoldings ?? 0) * (currentPrice ?? 0)
  }

  var rank: Int {
    Int(marketCapRank ?? 0)
  }

}

struct SparklineIn7D: Codable {
  let price: [Double]?
}
