//
//  ChartView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 05.04.2024.
//

import SwiftUI
import Charts

struct NewChartView: View {
  private let data: [Double]
  private let minY: Double
  private let maxY: Double
  private let startingDate: Date
  private let endingDate: Date
  private var dateData: [(date: Date, value: Double)]
  private let lineColor: Color
  private let linearGradient: LinearGradient

  init(coin: CoinModel) {
    data = coin.sparklineIn7D?.price ?? []
    minY = data.min() ?? 0
    maxY = data.max() ?? 0
    endingDate = Date(dateString: coin.lastUpdated ?? "")
    startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    dateData = []

    for index in data.indices {
      let currentDate = startingDate.addingTimeInterval(TimeInterval(3600 * index))
      dateData.append((currentDate, data[index]))
    }

    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange >= 0 ? Color.theme.greenClr : Color.theme.redClr

    linearGradient = LinearGradient(
      gradient: Gradient(colors: [
        lineColor.opacity(0.85),
        lineColor.opacity(0.05)
      ]),
      startPoint: .top,
      endPoint: .bottom
    )

  }

  var body: some View {
    Chart(dateData, id: \.date) {
      LineMark(
        x: .value("Date", $0.date),
        y: .value("Value", $0.value)
      )
      .foregroundStyle(lineColor)
      .lineStyle(StrokeStyle(lineWidth: 2))
      .interpolationMethod(.catmullRom)

      AreaMark (
        x: .value("Date", $0.date),
        yStart: .value("Value", minY),
        yEnd: .value("Value", $0.value)
      )
      .foregroundStyle(linearGradient)

    }
    .chartXAxis {
      AxisMarks(values: .stride(by: .day)) { _ in
        AxisTick()
        AxisGridLine()
        AxisValueLabel(format: .dateTime.weekday(.narrow))
      }
    }
    .font(.caption)
    .foregroundStyle(Color.theme.secondaryTextClr)
    .chartYScale(domain: [minY, maxY])
    .frame(height: 200)
  }
}


struct ChartView: View {
  private let data: [Double]
  private let minY: Double
  private let maxY: Double
  private let lineColor: Color
  private let startingDate: Date
  private let endingDate: Date

  @State var percentage: CGFloat = 0.0

  init(coin: CoinModel) {
    data = coin.sparklineIn7D?.price ?? []
    minY = data.min() ?? 0
    maxY = data.max() ?? 0

    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange >= 0 ? Color.theme.greenClr : Color.theme.redClr

    endingDate = Date(dateString: coin.lastUpdated ?? "")
    startingDate = endingDate.addingTimeInterval(-7*24*60*60)
  }

  var body: some View {
    VStack {
      chartView
        .frame(height: 200)
        .background(chartBackground)
        .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)

      chartXAxis
        .padding(.horizontal, 4)
    }
    .font(.caption)
    .foregroundStyle(Color.theme.secondaryTextClr)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.linear(duration: 1.5)) {
          percentage = 1.0
        }
      }
    }
  }
}

extension ChartView {

  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          let yAxis = maxY - minY
          let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height

          if index == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }

          path.addLine(to: CGPoint(x: xPosition, y: yPosition))

        }
      }
      .trim(from: 0, to: percentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 10, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
      .shadow(color: lineColor.opacity(0.25), radius: 10, x: 0, y: 30)
      .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
    }
  }

  private var chartBackground: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }

  private var chartYAxis: some View {
    VStack {
      Text(maxY.formatted(.number.notation(.compactName)))
      Spacer()
      Text(((maxY + minY)/2).formatted(.number.notation(.compactName)))
      Spacer()
      Text(minY.formatted(.number.notation(.compactName)))
    }
  }

  private var chartXAxis: some View {
    HStack {
      Text(startingDate.asString())
      Spacer()
      Text(endingDate.asString())
    }
  }

}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    NewChartView(coin: dev.coin)
  }
}
