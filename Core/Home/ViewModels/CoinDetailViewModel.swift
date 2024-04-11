//
//  CoinDetailViewModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

import SwiftUI
import Combine

final class CoinDetailViewModel: ObservableObject {
  private let coinDetailService: CoinDetailService

  @Published var coin: CoinModel

  @Published private(set) var overviewStatistics: [StatisticModel] = []
  @Published private(set) var additionalStatistics: [StatisticModel] = []
  @Published private(set) var coinDescription: String? = nil
  @Published private(set) var websiteURL: String? = nil
  @Published private(set) var redditURL: String? = nil

  private var cancellables = Set<AnyCancellable>()

  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailService = CoinDetailService(coin: coin)
    self.addSubscribers()
  }

  private func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapDataToStatistics)
      .sink { [weak self] returnedStatistics in
        guard let self else { return }
        self.overviewStatistics = returnedStatistics.overview
        self.additionalStatistics = returnedStatistics.additional
      }
      .store(in: &cancellables)

    coinDetailService.$coinDetails
      .sink { [weak self] returnedCoinDetail in
        guard let self else { return }
        self.coinDescription = returnedCoinDetail?.readableDescription
        self.websiteURL = returnedCoinDetail?.links?.homepage?.first
        self.redditURL = returnedCoinDetail?.links?.subredditUrl
      }
      .store(in: &cancellables)

  }

  private func mapDataToStatistics(
    coinDetailModel: CoinDetailModel?, coinModel: CoinModel
  ) -> (overview: [StatisticModel], additional: [StatisticModel]) {

    var overviewArray: [StatisticModel] = []

    if let price = coinModel.currentPrice,
       let priceChange = coinModel.priceChangePercentage24H {

      overviewArray.append(
        StatisticModel(
          title: "Current Price",
          value: price.formatted(.currency(code: "usd").precision(.fractionLength(2))),
          percentageChange: priceChange
        )
      )
    }

    if let marketCap = coinModel.marketCap,
       let marketCapChange = coinModel.marketCapChangePercentage24H {

      overviewArray.append(
        StatisticModel(
          title: "Market Capitalization",
          value: "$" + marketCap.formatted(.number.notation(.compactName)),
          percentageChange: marketCapChange
        )
      )
    }

    overviewArray.append(
      StatisticModel(
        title: "Rank",
        value: String(coinModel.rank)
      )
    )

    if let volume = coinModel.totalVolume {

      overviewArray.append(
        StatisticModel(
          title: "Rank",
          value: volume.formatted(.number)
        )
      )
    }

    var additionalArray: [StatisticModel] = []

    if let coinHigh = coinModel.high24H {

      additionalArray.append(
        StatisticModel(
          title: "24 High",
          value: coinHigh.formatted(.currency(code: "usd").precision(.fractionLength(2)))
        )
      )
    }

    if let coinLow = coinModel.low24H {

      additionalArray.append(
        StatisticModel(
          title: "24 Low",
          value: coinLow.formatted(.currency(code: "usd").precision(.fractionLength(2)))
        )
      )
    }

    if let priceChange = coinModel.priceChange24H,
       let percentChange = coinModel.priceChangePercentage24H {

      additionalArray.append(
        StatisticModel(
          title: "24 Price Change",
          value: priceChange.formatted(.currency(code: "usd").precision(.fractionLength(2))),
          percentageChange: percentChange
        )
      )
    }

    if let marketCapChange = coinModel.marketCapChange24H,
       let marketCapChangePercentage = coinModel.marketCapChangePercentage24H {

      additionalArray.append(
        StatisticModel(
          title: "24 Market Cap Change",
          value: "$" + marketCapChange.formatted(.number.notation(.compactName)),
          percentageChange: marketCapChangePercentage
        )
      )
    }

    if let blockTime = coinDetailModel?.blockTimeInMinutes {
      additionalArray.append(
        StatisticModel(
          title: "Block Time",
          value: "\(blockTime) min"
        )
      )
    }

    additionalArray.append(
      StatisticModel(
        title: "Hashing Algorithm",
        value: coinDetailModel?.hashingAlgorithm ?? "n/a"
      )
    )

    return (overviewArray, additionalArray)
  }

}
