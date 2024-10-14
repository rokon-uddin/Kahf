//
//  SecureBrowserViewModel.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/12/24.
//

import SwiftUI
import WebKit

final class SecureBrowserViewModel: ObservableObject {
  @Published var isVPNOn = false
  @Published var privacyLevel: PrivacyLevel = .medium
  @Published var canGoBack = false
  @Published var canGoForward = false
  @Published var urlString = Constants.defaultURL
  var webView: WKWebView
  private var proxyManager = ProxyManager()

  init() {
    self.webView = WKWebView(frame: .zero)
  }

  func goBack() {
    webView.goBack()
  }

  func goForward() {
    webView.goForward()
  }

  func loadUrl() {
    guard let url = URL(string: urlWithHTTP) else {
      return
    }
    webView.load(URLRequest(url: url))
  }

  func enableVPN() {
    proxyManager.enable(privacy: privacyLevel)
  }

  func disable() {
    proxyManager.disable()
  }

  private var urlWithHTTP: String {
    if urlString.hasPrefix("https://") {
      return urlString
    } else if urlString.hasPrefix("http://") {
      return urlString.replacingOccurrences(of: "http://", with: "https://")
    } else {
      return "https://\(urlString)"
    }
  }
}
