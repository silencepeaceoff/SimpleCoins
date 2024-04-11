//
//  CoinDetailView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?

  var body: some View {
    ZStack {
      if let coin {
        CoinDetailView(coin: coin)
      }
    }
  }

}

struct CoinDetailView: View {
  @StateObject private var vm: CoinDetailViewModel
  @State private var moreLessDescription = false

  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let spacing: CGFloat = 30

  init(coin: CoinModel) {
    _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
  }

  var body: some View {
    ScrollView {
      VStack {
        NewChartView(coin: vm.coin)
          .padding(.vertical)

        VStack(spacing: 20) {
          overviewTitle
          Divider()
          descriptionSection
          Divider()
          overviewGrid
          additionalTitle
          Divider()
          additionalGrid
          webLinks
        }
        .padding()
      }
    }
    .background(Color.theme.backgroundClr)
    .scrollIndicators(.hidden)
    .navigationTitle(vm.coin.name ?? "")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        navigationBarTrailingItem
      }
    }

  }
}

extension CoinDetailView {

  private var navigationBarTrailingItem: some View {
    HStack {
      CoinImageView(coin: vm.coin)
        .frame(width: 24, height: 24)

      Text(vm.coin.symbol?.uppercased() ?? "n/a")
        .foregroundStyle(Color.theme.secondaryTextClr)
    }
  }

  private var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundStyle(Color.theme.accentClr)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var descriptionSection: some View {
    ZStack {
      if let coinDescription = vm.coinDescription,
         !coinDescription.isEmpty {

        VStack {
          Text(coinDescription)
            .lineLimit(moreLessDescription ? nil : 3)
            .font(.callout)
            .foregroundStyle(Color.theme.secondaryTextClr)

          Button {
            withAnimation(.easeInOut) {
              moreLessDescription.toggle()
            }
          } label: {
            Text(moreLessDescription ? "read less" : "read more")
              .foregroundStyle(.blue)
              .font(.callout.weight(.semibold).italic())
              .frame(maxWidth: .infinity, alignment: .trailing)

          }

        }

      }
    }
  }

  private var webLinks: some View {
    HStack {
      if let websiteURL = vm.websiteURL,
         let url = URL(string: websiteURL) {

        Link("Website", destination: url)
      }

      Spacer()

      if let redditURL = vm.redditURL,
         let url = URL(string: redditURL) {

        Link("Reddit", destination: url)
      }
    }
    .tint(.blue)
    .frame(maxWidth: .infinity, alignment: .center)

  }

  private var overviewGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      content: {
        ForEach(vm.overviewStatistics) { stat in
          StatisticView(statistic: stat)
        }
      })
  }

  private var additionalTitle: some View {
    Text("Additional Details")
      .font(.title)
      .bold()
      .foregroundStyle(Color.theme.accentClr)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var additionalGrid: some View {
    LazyVGrid(
      columns: columns,
      alignment: .leading,
      spacing: spacing,
      content: {
        ForEach(vm.additionalStatistics) { stat in
          StatisticView(statistic: stat)
        }
      })
  }

}

struct CoinDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      CoinDetailView(coin: dev.coin)
    }
  }
}
