//
//  CoinImageService.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import SwiftUI
import Combine

final class CoinImageService {
  @Published private(set) var image: UIImage? = nil

  private let coin: CoinModel
  
  private var imageSubscription: AnyCancellable?

  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"

  //MARK: - Init

  init(coin: CoinModel) {
    self.coin = coin
    loadCoinImage()
  }

  private func loadCoinImage() {
    if let coinName = coin.id,
       let savedImage = fileManager.load(imageName: coinName, folderName: folderName) {

      image = savedImage

    } else {
      downloadCoinImage()
    }
  }

  private func downloadCoinImage() {
    guard let urlString = coin.image,
          let coinName = coin.id,
          let url = URL(string: urlString) else { return }

    imageSubscription = NetworkingManager.download(url: url)
      .tryMap({ data -> UIImage? in
        UIImage(data: data)
      })
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handle, receiveValue: { [weak self] returnedImage in
        guard let self,
              let downloadedImage = returnedImage else { return }

        self.image = returnedImage
        self.imageSubscription?.cancel()
        self.fileManager.save(image: downloadedImage, imageName: coinName, folderName: self.folderName)
      })
  }

}
