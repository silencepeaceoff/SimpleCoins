//
//  SimpleCoinsApp.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

@main
struct SimpleCoinsApp: App {
  @StateObject private var vm = CoinsListViewModel()
  @State private var showLaunchView = true

  init() {
    // Change Color navigationTitle
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentClr)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentClr)]

    // Change Color topBar (navigationTitle background when it go inline)
    // UINavigationBar.appearance().barTintColor = UIColor(Color.theme.accentClr)
  }

  var body: some Scene {
    WindowGroup {

      ZStack {
        NavigationStack {
          CoinsListView()
            .toolbar(.hidden)
        }
        .environmentObject(vm)
        .tint(Color.theme.accentClr) // Change color for tabBarItems

        ZStack {
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .leading))
          }
        }
        .zIndex(2.0) // priority
      }

    }
  }
}
