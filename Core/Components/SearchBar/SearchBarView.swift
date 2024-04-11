//
//  SearchBarView.swift
//  SimpleCoins
//
//  Created by Dmitrii Tikhomirov on 02.04.2024.
//

import SwiftUI

struct SearchBarView: View {
  @Binding var searchText: String
  @FocusState private var searchTextIsFocused: Bool

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundStyle(
          searchText.isEmpty ? Color.theme.secondaryTextClr : Color.theme.accentClr
        )

      TextField("Search by name or symbol…", text: $searchText)
        .focused($searchTextIsFocused)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .foregroundStyle(Color.theme.accentClr)
        .overlay (
          Image(systemName: "xmark.circle.fill")
            .padding()
            .offset(x: 10)
            .foregroundStyle(Color.theme.accentClr)
            .opacity(searchText.isEmpty ? 0.0 : 1.0)
            .disabled(searchText.isEmpty)
            .onTapGesture {
              searchText = ""
              searchTextIsFocused = false
            }
            .focused($searchTextIsFocused)
          , alignment: .trailing
        )
    }
    .font(.headline)
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 25.0)
        .fill(Color.theme.backgroundClr)
        .shadow(color: Color.theme.accentClr.opacity(0.15), radius: 10)
    )
    .padding()
  }
}

#Preview {
  SearchBarView(searchText: .constant(""))
}
