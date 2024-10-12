# Kahf Browser

This project is a Swift-based secure browser built using the `App Proxy Network Extension` for enhanced privacy and security. The browser intercepts and manages network traffic securely, allowing users to browse the web through a VPN-enabled connection.

## Features

- **Web Browsing**: Browse websites using the integrated `SwiftUIWebView` component.
- **Privacy Control**: Users can adjust the privacy level via an in-app picker, toggling between predefined settings.
- **VPN Toggle**: Enable or disable a VPN connection directly from the browser interface.
- **Navigation**: Standard browser navigation with forward and backward buttons.
- **App Proxy Integration**: 
  - Intercepts network traffic using the `App Proxy Network Extension` and forwards data securely.
  - Logs TCP and UDP traffic, allowing inspection and optional modification of network packets.
  - Supports monitoring of network requests to ensure secure communication.

## Code Overview

- **SecureBrowserView.swift**: The main UI of the browser, including navigation and URL input.
- **SwiftUIWebView.swift**: A wrapper around a `WKWebView`, integrated with SwiftUI.
- **SecureBrowserViewModel.swift**: The view model that handles browser logic, such as loading URLs and managing VPN state.
- **ProxyManager.swift**: Manages VPN settings and controls network traffic.
- **AppProxyProvider.swift**: Handles the interception of TCP and UDP traffic using the Network Extension framework.
- **Constants.swift & PrivacyLevel.swift**: Define configuration constants and privacy levels available for the browser.

## How It Works

1. **VPN Activation**: Users can toggle the VPN setting, which is managed by the `ProxyManager` class. It uses `App Proxy Network Extension` to securely route traffic.
2. **Traffic Interception**: The `AppProxyProvider` captures and optionally modifies network traffic, ensuring that the browser communicates securely with remote servers.
3. **WebView Interface**: The `SwiftUIWebView` provides a simple interface for browsing, while `SecureBrowserViewModel` controls the flow of data and interactions.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.8+

## Installation

To test the project, clone the repository and open it in Xcode. Please note that Network Extension functionality is not supported in the simulator, so you’ll need to build and run the app on a physical device. Additionally, the provider extensions require code signing with the appropriate entitlements, meaning you must be enrolled in the Apple Developer Program to test the app properly.