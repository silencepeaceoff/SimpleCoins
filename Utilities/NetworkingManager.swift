//
//  NetworkingManager.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import Foundation
import Combine

final class NetworkingManager {

  enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown

    var errorDescription: String? {
      switch self {
      case .badURLResponse(url: let url):
        "Bad Response from URL: \(url)"
      case .unknown:
        "Unknown error occured"
      }
    }
  }

  static func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap({ try handleUrlResponse(output: $0, url: url) })
      .retry(3)
      .eraseToAnyPublisher()
  }

  static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      throw NetworkingError.badURLResponse(url: url)
    }
    return output.data
  }

  static func handle(completion: Subscribers.Completion<Error>){
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
    }
  }

}
