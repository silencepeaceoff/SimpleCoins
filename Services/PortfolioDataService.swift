//
//  PortfolioDataService.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 04.04.2024.
//

import Foundation
import CoreData

final class PortfolioDataService {
  private let container: NSPersistentContainer
  private let containerName: String = "PortfolioContainer"
  private let entityName: String = "PortfolioEntity"

  @Published private(set) var savedEntities: [PortfolioEntity] = []

  //MARK: - Init

  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error {
        print("Error loading CoreData: \(error.localizedDescription)")
      } else {
        self.getPortfolio()
      }
    }
  }

  //MARK: - Public func

  func updatePortfolio(coin: CoinModel, amount: Double) {
    if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
      if amount > 0 {
        update(entity: entity, amount: amount)
      } else {
        delete(entity: entity)
      }
    } else {
      addToPortfolio(coin: coin, amount: amount)
    }
  }

  //MARK: - Private func

  private func getPortfolio() {
    let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)

    do {
      savedEntities = try container.viewContext.fetch(request)
    } catch let error {
      print("Error Fetching Request: \(error.localizedDescription)")
    }
  }

  private func addToPortfolio(coin: CoinModel, amount: Double) {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    applyChanges()
  }

  private func update(entity: PortfolioEntity, amount: Double) {
    entity.amount = amount
    applyChanges()
  }

  private func delete(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }

  private func save() {
    do {
      try container.viewContext.save()
    } catch let error {
      print("Error Saving to CoreData: \(error.localizedDescription)")
    }
  }

  private func applyChanges() {
    save()
    getPortfolio()
  }

}
