//
//  CoinsListViewModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI
import Combine

final class CoinsListViewModel: ObservableObject {
  @Published private(set) var statistics: [StatisticModel] = []
  @Published private(set) var allCoins: [CoinModel] = []
  @Published private(set) var portfolioCoins: [CoinModel] = []

  @Published var searchText = ""
  @Published var sortOption: SortOption = .rank

  private let coinDataService = CoinDataService()
  private let marketDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  
  private var cancellables = Set<AnyCancellable>()

  enum SortOption {
    case rank, rankReversed
    case holdings, holdingsReversed
    case price, priceReversed
  }

  init() {
    addSubscribers()
  }

  func addSubscribers() {

    // Updates allCoins
    $searchText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] returnedCoins in
        guard let self else { return }

        self.allCoins = returnedCoins
      }
      .store(in: &cancellables)

    // Updates portfolio
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolio)
      .sink { [weak self] returnedCoins in
        guard let self else { return }
        self.portfolioCoins = sortHoldings(coins: returnedCoins)
      }
      .store(in: &cancellables)

    // Updates marketData
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(marketData)
      .sink { [weak self] returnedStats in
        guard let self else { return }

        self.statistics = returnedStats
      }
      .store(in: &cancellables)

  }

  func reloadData() {
    coinDataService.getCoins()
    marketDataService.getMarketData()
    HapticManager.notification(type: .success)
  }

  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }

  private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
    var updatedCoins = filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coins: &updatedCoins)
    return updatedCoins
  }

  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else { return coins }

    let lowercasedText = text.lowercased()

    return coins.filter { coin -> Bool in
      guard let coinName = coin.name,
            let coinSymbol =  coin.symbol,
            let coinId =  coin.id else { return false }

      return coinName.lowercased().contains(lowercasedText) ||
      coinSymbol.lowercased().contains(lowercasedText) ||
      coinId.lowercased().contains(lowercasedText)
    }
  }

  private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
    switch sort {
    case .rank:
      coins.sort(by: { $0.rank < $1.rank })
    case .rankReversed:
      coins.sort(by: { $0.rank > $1.rank })
    case .price, .holdings:
      coins.sort(by: { $0.currentPrice ?? 0 > $1.currentPrice ?? 0 })
    case .priceReversed, .holdingsReversed:
      coins.sort(by: { $0.currentPrice ?? 0 < $1.currentPrice ?? 0 })
    }
  }

  private func sortHoldings(coins: [CoinModel]) -> [CoinModel] {
    switch sortOption {
    case .holdings:
      return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
    case .holdingsReversed:
      return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
    default:
      return coins
    }
  }

  private func mapAllCoinsToPortfolio(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
    allCoins.compactMap { coin -> CoinModel? in
      guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
        return nil
      }

      return coin.updateHoldings(amount: entity.amount)
    }
  }


  private func marketData(model: MarketData?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats: [StatisticModel] = []

    guard let data = model?.data else { return stats }

    let marketCap = StatisticModel(title: "Market Cap", value: data.marketCapUsd, percentageChange: data.marketCapChangePercentage24HUsd)
    let totalVolume = StatisticModel(title: "24H Volume", value: data.totalVolumeUsd)
    let marketCapPercentage = StatisticModel(title: "BTC Cap", value: data.marketCapPercentageBtc)

    let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)

    let previousValue = portfolioCoins.map { coin -> Double in
      if let percentChange = coin.priceChangePercentage24H {

        return coin.currentHoldingsValue / (1 + percentChange / 100)
      }
      return 0
    }.reduce(0, +)

    let portfolioPercentChange = ((portfolioValue - previousValue) / portfolioValue) * 100

    let portfolio = StatisticModel(
      title: "Portfolio Value",
      value: portfolioValue.formatted(.currency(code: "usd").precision(.fractionLength(2))),
      percentageChange: portfolioPercentChange
    )

    stats.append(contentsOf: [
      marketCap, totalVolume, marketCapPercentage, portfolio
    ])

    return stats
  }

}
