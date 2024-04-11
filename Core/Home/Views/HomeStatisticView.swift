//
//  HomeStatisticView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

struct HomeStatisticView: View {
  @EnvironmentObject private var vm: CoinsListViewModel
  @Binding var showPortfolio: Bool


  var body: some View {
    HStack {
      ForEach(vm.statistics) { statistic in
        StatisticView(statistic: statistic)
          .frame(width: ScreenSize.instance.getWidth() / 3)
      }
    }
    .frame(width: ScreenSize.instance.getWidth(), alignment: showPortfolio ? .trailing : .leading)
  }
}

struct HomeStatisticView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatisticView(showPortfolio: .constant(true))
      .environmentObject(dev.homeVM)
  }
}
