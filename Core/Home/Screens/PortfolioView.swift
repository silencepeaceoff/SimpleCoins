//
//  PortfolioView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 03.04.2024.
//

import SwiftUI

struct PortfolioView: View {
  @EnvironmentObject private var vm: CoinsListViewModel
  @FocusState private var quantityIsFocused: Bool
  @State private var selectedCoin: CoinModel? = nil
  @State private var quantityText: String = ""

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 4) {
          SearchBarView(searchText: $vm.searchText)

          coinLogoList

          if let coin = selectedCoin {
            portfolioInputSection(coin: coin)
          }
        }
      }
      .background(Color.theme.backgroundClr)
      .navigationTitle("Edit Portfolio")
      .toolbar {
        ToolbarItemGroup(placement: .cancellationAction) {
          DismissButton()
        }
        ToolbarItemGroup(placement: .confirmationAction) {
          saveButton(with: nil)
        }
        ToolbarItemGroup(placement: .keyboard) {
          saveButton(with: "Save")
        }
      }
      .onChange(of: vm.searchText) {
        if vm.searchText.isEmpty {
          selectedCoin = nil
          quantityIsFocused = false
        }
      }
      .onTapGesture {
        hideKeyboard()
      }
    }
  }

  private func saveButtonPressed() {
    guard let coin = selectedCoin,
          let amount = Double(quantityText) else { return }

    vm.updatePortfolio(coin: coin, amount: amount)

    withAnimation(.easeIn) {
      quantityIsFocused = false
      selectedCoin = nil
      vm.searchText = ""
    }
  }

  private func portfolioInputSection(coin: CoinModel) -> some View {
    VStack(spacing: 12) {

      HStack {
        if let symbol = coin.symbol,
           let currentPrice = coin.currentPrice {

          Text("Current price of \(symbol.uppercased()):")
          Spacer()
          Text(currentPrice, format: .currency(code: "usd"))
        }
      }

      Divider()

      HStack {
        Text("Amount in your portfolio:")
        Spacer()
        TextField("Example: 1.73", text: $quantityText)
          .keyboardType(.decimalPad)
          .multilineTextAlignment(.trailing)
          .focused($quantityIsFocused)
      }

      Divider()

      HStack {
        Text("Current Value:")
        Spacer()
        Text(getCurrentValue(), format: .currency(code: "usd"))
      }
    }
    .padding()
    .font(.headline)
    .transaction { $0.animation = nil }
  }

  private func getCurrentValue() -> Double {
    if let quantity = Double(quantityText),
       let currentPrice = selectedCoin?.currentPrice {

      return quantity * currentPrice
    }

    return 0.0
  }

}

extension PortfolioView {

  private var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 8) {
        ForEach(vm.allCoins) { coin in
          CoinLogo(coin: coin)
            .frame(width: 56, height: 96)
            .padding(4)
            .onTapGesture {
              withAnimation(.easeIn) {
                updateSelectedCoin(coin: coin)
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 9)
                .stroke(selectedCoin?.id == coin.id ? Color.theme.greenClr : Color.clear, lineWidth: 1.0)
            )
        }
      }
      .padding(.vertical, 4)
      .padding(.leading, 10)
    }
  }

  private func updateSelectedCoin(coin: CoinModel) {
    selectedCoin = coin
    if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
       let amount = portfolioCoin.currentHoldings {

      quantityText = "\(amount)"

    } else {
      quantityText = ""
    }

  }

  private func saveButton(with: String?) -> some View {
    Button {
      saveButtonPressed()
    } label: {
      if let str = with {
        Text(str)
          .font(.headline)
          .foregroundStyle(Color.theme.greenClr)
      } else {
        Image(systemName: "checkmark")
          .foregroundStyle(Color.theme.greenClr)
      }
    }
    .disabled(selectedCoin == nil && selectedCoin?.currentHoldings == Double(quantityText))
    .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)

  }

}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      PortfolioView()
        .environmentObject(dev.homeVM)
    }
  }
}
