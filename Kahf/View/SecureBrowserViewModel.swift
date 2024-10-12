//
//  SecureBrowserViewModel.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/12/24.
//

import Observation
import SwiftUI
import WebKit

@Observable
final class SecureBrowserViewModel {
  var isVPNOn = false
  var privacyLevel: PrivacyLevel = .medium
  var canGoBack = false
  var canGoForward = false
  var webView: WKWebView
  var urlString = Constants.defaultURL
  @ObservationIgnored private var proxyManager = ProxyManager()

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
    guard let url = URL(string: urlString) else {
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
}
