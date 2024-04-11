//
//  MarketDataModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import Foundation

struct MarketData: Codable {
  let data: MarketDataModel?
}

struct MarketDataModel: Codable {
  let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int?
  let markets: Int?
  let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]?
  let marketCapChangePercentage24HUsd: Double?
  let updatedAt: Int?

  var marketCapUsd: String {
    getMarketDataUsd(from: totalMarketCap)
  }

  var totalVolumeUsd: String {
    getMarketDataUsd(from: totalVolume)
  }

  var marketCapPercentageBtc: String {
    getMarketDataBtc(from: marketCapPercentage)
  }

  private func getMarketDataUsd(from: [String: Double]?) -> String {
    if let data = from?.first(where: { $0.key == "usd" }) {
      let compactNum = data.value.formatted(.number.notation(.compactName))
      return "$" + compactNum
    }

    return ""
  }

  private func getMarketDataBtc(from: [String: Double]?) -> String  {
    if let data = from?.first(where: { $0.key == "btc" }) {
      let compact = data.value.formatted(.number.precision(.fractionLength(2)))
      return compact + "%"
    }

    return ""
  }

}
