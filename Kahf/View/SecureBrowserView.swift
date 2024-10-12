//
//  SecureBrowserView.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/12/24.
//

import SwiftUI

struct SecureBrowserView: View {
  @FocusState private var isFocused: Bool
  @State private var viewModel = SecureBrowserViewModel()

  var body: some View {
    VStack(spacing: 0) {
      SwiftUIWebView(viewModel: $viewModel)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
          viewModel.loadUrl()
        }

      VStack(spacing: 0) {
        TextView()
          .padding(.horizontal, 8)
          .padding(.vertical, 10)
        if !isFocused {
          BottomNavigationView()
            .padding(.horizontal, 8)
        }
      }
      .animation(.none, value: isFocused)
      .padding(.horizontal, 8)
      .background(Color(.systemGray5))
    }
  }

  @ViewBuilder
  private func TextView() -> some View {
    TextField(
      "Enter URL or search",
      text: $viewModel.urlString
    )
    .onSubmit {
      viewModel.loadUrl()
    }
    .focused($isFocused)
    .submitLabel(.go)
    .padding(.all, 10)
    .background(Color(.systemGray6))
    .cornerRadius(8)
  }

  @ViewBuilder
  private func BottomNavigationView() -> some View {
    HStack(spacing: 0) {
      Button(action: {
        viewModel.goBack()
      }) {
        Image(systemName: "chevron.backward")
          .font(.title2)
      }
      .disabled(!viewModel.canGoBack)
      .padding(.trailing, 16)

      Button(action: {
        viewModel.goForward()
      }) {
        Image(systemName: "chevron.forward")
          .font(.title2)
      }
      .disabled(!viewModel.canGoForward)

      Spacer()

      Text("Privacy")
      Picker("", selection: $viewModel.privacyLevel) {
        ForEach(PrivacyLevel.allCases, id: \.self) {
          Text($0.rawValue)
        }
      }
      .pickerStyle(.menu)
      .padding(.trailing, 16)

      Toggle("VPN", isOn: $viewModel.isVPNOn)
        .frame(width: 92)
        .onChange(of: viewModel.isVPNOn){ _, _ in
          togglePrivacy()
        }
    }
  }

  private func togglePrivacy() {
    viewModel.isVPNOn ? viewModel.enableVPN() : viewModel.disable()
  }
}

#Preview {
  SecureBrowserView()
    .preferredColorScheme(.dark)
}
