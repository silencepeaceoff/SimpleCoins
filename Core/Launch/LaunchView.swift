//
//  LaunchView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 10.04.2024.
//

import SwiftUI

struct LaunchView: View {
  @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
  @State private var showLoadingText: Bool = false
  @Binding var showLaunchView: Bool

  @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  @State private var counter: Int = 0

  var body: some View {

    ZStack {
      Color.black
        .ignoresSafeArea()

      Image("logo")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)

      ZStack {
        if showLoadingText {
          HStack(spacing: 2) {
            ForEach(loadingText.indices, id: \.self) { index in
              Text(loadingText[index])
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.launchAccentClr)
                .offset(y: counter == index ? -10 : 0)
            }
          }
          .transition(.scale.animation(.easeInOut))
        }
      }
      .offset(y: 80)

    }
    .onAppear {
      showLoadingText.toggle()
    }
    .onReceive(timer, perform: { _ in
      withAnimation(.spring()) {
        if counter == loadingText.count {
          counter = 0
          showLaunchView = false
        } else {
          counter += 1
        }
      }
    })

  }
}

#Preview {
  LaunchView(showLaunchView: .constant(true))
}
