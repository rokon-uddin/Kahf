//
//  SwiftUIWebView.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/12/24.
//

import SwiftUI
import WebKit

struct SwiftUIWebView: UIViewRepresentable {
  @ObservedObject var viewModel: SecureBrowserViewModel

  func makeUIView(context: Context) -> WKWebView {
    let webView = viewModel.webView
    webView.navigationDelegate = context.coordinator
    webView.allowsBackForwardNavigationGestures = true
    return webView
  }

  func updateUIView(_ uiView: WKWebView, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: SwiftUIWebView

    init(_ parent: SwiftUIWebView) {
      self.parent = parent
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      parent.viewModel.canGoBack = webView.canGoBack
      parent.viewModel.canGoForward = webView.canGoForward
      parent.viewModel.urlString = webView.url?.absoluteString ?? parent.viewModel.urlString
    }
  }
}
