//
//  StatisticView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

struct StatisticView: View {

  let statistic: StatisticModel

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(statistic.title)
          .font(.caption)
          .foregroundStyle(Color.theme.secondaryTextClr)

        Text(statistic.value)
          .font(.headline)
          .bold()

        if let percentageChange = statistic.percentageChange {
          percentageChangeView(value: percentageChange)
        } else {
          percentageChangeView(value: 0.0)
            .opacity(0.0)
        }

      }
    }
  }

  private func percentageChangeView(value: Double) -> some View {
    HStack(spacing: 2) {
      Image(systemName: value >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
        .font(.callout)

      Text(value / 100, format: .percent.precision(.fractionLength(2)))
        .bold()
    }
    .foregroundStyle(
      value >= 0 ? Color.theme.greenClr : Color.theme.redClr
    )

  }

}

struct StatisticView_Previews: PreviewProvider {
  static var previews: some View {
    StatisticView(statistic: dev.statisticView)
  }
}
