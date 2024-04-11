//
//  LocalFileManager.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import SwiftUI

final class LocalFileManager {
  
  static let instance = LocalFileManager()
  private init() {}

  func save(image: UIImage, imageName: String, folderName: String) {
    // Create Folder
    createFolderIfNeeded(folderName: folderName)

    // Get Path for Image
    guard let data = image.pngData(),
    let url = getUrlFor(imageName: imageName, folderName: folderName) else { return }

    // Save Image to path
    do {
      try data.write(to: url)
    } catch let error {
      print("Error saving image. Image Name: \(imageName). \(error.localizedDescription)")
    }
  }

  func load(imageName: String, folderName: String) -> UIImage? {
    guard let url = getUrlFor(imageName: imageName, folderName: folderName),
          FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) else { return nil }

    return UIImage(contentsOfFile: url.path(percentEncoded: false))
  }

  private func createFolderIfNeeded(folderName: String) {
    guard let url = getUrlFor(folderName: folderName) else { return }

    if !FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
      } catch let error {
        print("Error creating directory. Folder Name: \(folderName). \(error.localizedDescription)")
      }
    }
  }

  private func getUrlFor(folderName: String) -> URL? {
    guard let url = FileManager.default.urls(
      for: .cachesDirectory, in: .userDomainMask
    ).first else { return nil }

    return url.appendingPathComponent(folderName)
  }

  private func getUrlFor(imageName: String, folderName: String) -> URL? {
    guard let folderUrl = getUrlFor(folderName: folderName) else { return nil }

    return folderUrl.appendingPathComponent(imageName + ".png")
  }

}
