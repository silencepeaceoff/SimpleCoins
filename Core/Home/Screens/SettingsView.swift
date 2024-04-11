//
//  SettingsView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 09.04.2024.
//

import SwiftUI

struct SettingsView: View {
  let coingeckoUrl = URL(string: "https://www.coingecko.com/")!
  let linkedInUrl = URL(string: "https://www.linkedin.com/in/silencepeaceoff/")!
  let githubUrl = URL(string: "https://github.com/silencepeaceoff")!

  var body: some View {
    NavigationStack {

      List {
        appSection
          .listRowBackground(Color.theme.backgroundClr.opacity(0.5))
        apiSection
          .listRowBackground(Color.theme.backgroundClr.opacity(0.5))
        personalSection
          .listRowBackground(Color.theme.backgroundClr.opacity(0.5))
      }
      .scrollContentBackground(.hidden)
      .background(Color.theme.backgroundClr.opacity(0.5))
      .listStyle(.grouped)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          DismissButton()
        }
      }
      .navigationTitle("Settings")

    }
  }
}

extension SettingsView {

  private var appSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)

        Text("This app uses MVVM Architecture, Combine & CoreData.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accentClr)
      }
      .padding(.vertical)

      Link("GitHub", destination: githubUrl)
        .foregroundStyle(.blue)
        .bold()

    } header: {
      Text("App")
    }
  }

  private var apiSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("CoinGecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)

        Text("The cryptocurrency data that used in this app comes from a free API CoinGecko with some delay.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accentClr)
      }
      .padding(.vertical)

      Link("CoinGecko", destination: coingeckoUrl)
        .foregroundStyle(.blue)
        .bold()

    } header: {
      Text("CoinGecko API")
    }
  }

  private var personalSection: some View {
    Section {
      VStack(alignment: .leading) {
        Image("profile")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
          .clipShape(Circle())

        Text("Dmitrii Tikhomirov - iOS Developer")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundStyle(Color.theme.accentClr)
      }
      .padding(.vertical)

      Link("LinkedIn", destination: linkedInUrl)
        .foregroundStyle(.blue)
        .bold()

    } header: {
      Text("Personal")
    }
  }

}

#Preview {
  SettingsView()
}
