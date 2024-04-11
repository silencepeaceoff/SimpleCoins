//
//  CoinsListView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 01.04.2024.
//

import SwiftUI

struct CoinsListView: View {
  @EnvironmentObject private var vm: CoinsListViewModel

  @State private var showPortfolio: Bool = false
  @State private var showPortfolioView: Bool = false

  @State private var selectedCoin: CoinModel? = nil
  @State private var showDetailView: Bool = false

  @State private var showSettingsView: Bool = false

  var body: some View {
    ZStack {
      Color.theme.backgroundClr
        .ignoresSafeArea()
        .sheet(isPresented: $showPortfolioView, content: {
          PortfolioView()
            .environmentObject(vm)
            .overlay {
              if vm.allCoins.isEmpty && !vm.searchText.isEmpty {
                portfolioSearchUnavailableView
              }
            }
        })

      VStack {
        homeHeader
        HomeStatisticView(showPortfolio: $showPortfolio)
        SearchBarView(searchText: $vm.searchText)
        columnTitles

        if !showPortfolio {
          allCoinsList
            .transition(.move(edge: .leading))
            .overlay {
              if vm.allCoins.isEmpty && vm.searchText.isEmpty {
                allCoinsListUnavailableView
              } else if vm.allCoins.isEmpty && !vm.searchText.isEmpty {
                allCoinsSearchUnavailableView
              }
            }
        } else {
          portfolioCoinsList
            .transition(.move(edge: .trailing))
            .overlay {
              if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                portfolioUnavailableView
              }
            }
        }

        Spacer(minLength: 0)
      }
      .sheet(isPresented: $showSettingsView, content: {
        SettingsView()
      })

    }
    .navigationDestination(isPresented: $showDetailView, destination: {
      DetailLoadingView(coin: $selectedCoin)
    })
    .refreshable {
      vm.reloadData()
    }
    .onTapGesture {
      hideKeyboard()
    }
  }
}

//MARK: - Private Views
extension CoinsListView {

  private var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? "plus" : "info")
        .transaction { $0.animation = nil }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          } else {
            showSettingsView.toggle()
          }
        }

      Spacer()

      Text(showPortfolio ? "Portfolio" : "Live Prices")
        .font(.headline).fontWeight(.heavy)
        .foregroundStyle(Color.theme.accentClr)
        .transaction { $0.animation = nil }

      Spacer()

      CircleButtonView(iconName: "chevron.right")
        .rotationEffect(showPortfolio ? .degrees(180) : .zero)
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }

  private var allCoinsList: some View {
    List(vm.allCoins) { coin in
      CoinRowView(coin: coin, showHoldingsColumn: false)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
        .onTapGesture {
          segue(coin: coin)
        }
        .listRowBackground(Color.theme.backgroundClr)
    }
    .listStyle(.plain)
  }

  private var allCoinsListUnavailableView: some View {
    ContentUnavailableView {
      Label("Some problems with internet connection or server.", systemImage: "wifi.slash")
    } description: {
      Text("Please check your internet connection.")
    }
  }

  private var allCoinsSearchUnavailableView: some View {
    ContentUnavailableView {
      Label("There is no \(vm.searchText) coins", systemImage: "xmark.circle.fill")
    } description: {
      Text("Please check your spelling.")
    }
  }

  private var portfolioCoinsList: some View {
    List(vm.portfolioCoins) { coin in
      CoinRowView(coin: coin, showHoldingsColumn: true)
        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
        .onTapGesture {
          segue(coin: coin)
        }
        .listRowBackground(Color.theme.backgroundClr)
    }
    .listStyle(.plain)
  }

  private var portfolioUnavailableView: some View {
    ContentUnavailableView {
      Label("You haven't added any coins to your portfolio yet.", systemImage: "xmark.circle.fill")
    } description: {
      Text("Please click the plus button to add some.")
    }
  }

  private var portfolioSearchUnavailableView: some View {
    ContentUnavailableView {
      Label("There is no \(vm.searchText) coins", systemImage: "xmark.circle.fill")
    } description: {
      Text("Please check your spelling.")
    }
  }

  private var columnTitles: some View {
    HStack {
      Button {
        withAnimation(.default) {
          vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
        }
      } label: {
        HStack(spacing: 4) {
          Text("Coin")

          if vm.sortOption == .rank {
            Image(systemName: "chevron.down")
          } else if vm.sortOption == .rankReversed {
            Image(systemName: "chevron.up")
          }
        }
      }

      Spacer()

      if showPortfolio {
        Button {
          withAnimation(.default) {
            vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        } label: {
          HStack(spacing: 4) {
            Text("Holdings")

            if vm.sortOption == .holdings {
              Image(systemName: "chevron.down")
            } else if vm.sortOption == .holdingsReversed {
              Image(systemName: "chevron.up")
            }
          }
        }
      }

      Button {
        withAnimation(.default) {
          vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
        }
      } label: {
        HStack(spacing: 4) {
          Text("Price")

          if vm.sortOption == .price {
            Image(systemName: "chevron.down")
          } else if vm.sortOption == .priceReversed {
            Image(systemName: "chevron.up")
          }

        }
      }
      .frame(width: ScreenSize.instance.getWidth() / 3.5, alignment: .trailing)

    }
    .font(.caption)
    .foregroundStyle(Color.theme.secondaryTextClr)
    .padding(.horizontal)
  }

}

//MARK: - Private Func
extension CoinsListView {

  private func segue(coin: CoinModel) {
    selectedCoin = coin
    showDetailView.toggle()
  }

}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      CoinsListView()
    }
    .environmentObject(dev.homeVM)
  }
}
