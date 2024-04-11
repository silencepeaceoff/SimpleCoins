//
//  CoinImageViewModel.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
  @Published private(set) var image: UIImage? = nil
  @Published private(set) var isLoading: Bool = false

  private let coin: CoinModel
  private let dataService: CoinImageService
  private var cancellables = Set<AnyCancellable>()

  init(coin: CoinModel) {
    self.coin = coin
    self.dataService = CoinImageService(coin: coin)
    self.addSubscribers()
  }

  private func addSubscribers() {
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] returnedImage in
        self?.image = returnedImage
      }
      .store(in: &cancellables)
  }

}
