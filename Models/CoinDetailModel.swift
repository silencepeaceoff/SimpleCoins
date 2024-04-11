//
//  CoinDetailModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

struct CoinDetailModel: Codable {
  let id, symbol, name: String?
  let blockTimeInMinutes: Int?
  let hashingAlgorithm: String?
  let categories: [String]?
  let description: Description?
  let links: Links?

  var readableDescription: String? {
    return description?.en?.removingHtml
  }
}

struct Links: Codable {
  let homepage: [String]?
  let subredditUrl: String?
}

struct Description: Codable {
  let en: String?
}
