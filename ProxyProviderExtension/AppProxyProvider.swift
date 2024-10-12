//
//  AppProxyProvider.swift
//  ProxyProviderExtension
//
//  Created by Mohammed Rokon Uddin on 10/10/24.
//

import NetworkExtension

class AppProxyProvider: NEAppProxyProvider {

  override func startProxy(options: [String: Any]? = nil, completionHandler: @escaping (Error?) -> Void) {
    // Add code here to start the process of connecting the tunnel.
    ProxyLogger.shared.log(message: "Starting Proxy")
    completionHandler(nil)
  }

  override func stopProxy(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
    ProxyLogger.shared.log(message: "Stopping Proxy")
    completionHandler()
  }

  override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
    // Add code here to handle the message.
    if let handler = completionHandler {
      handler(messageData)
    }
  }

  override func sleep(completionHandler: @escaping () -> Void) {
    // Add code here to get ready to sleep.
    completionHandler()
  }

  override func wake() {
    // Add code here to wake up.
  }

  override func handleNewFlow(_ flow: NEAppProxyFlow) -> Bool {
    // Handle incoming network flows
    if let tcpFlow = flow as? NEAppProxyTCPFlow {
      logTCPRequest(with: tcpFlow)
    } else if let udpFlow = flow as? NEAppProxyUDPFlow {
      logUDPRequest(with: udpFlow)
    }

    guard let tcpFlow = flow as? NEAppProxyTCPFlow else {
      return false
    }

    // Inspect and forward network packets as needed
    tcpFlow.open(withLocalEndpoint: nil) { error in
      if let error = error {
        ProxyLogger.shared.log(error: "Failed to open TCP flow: \(error)")
        return
      }

      // Read the flow's data and forward it to the remote server
      tcpFlow.readData { data, error in
        guard let data = data, error == nil else {
          ProxyLogger.shared.log(error: "Failed to read data: \(error?.localizedDescription ?? "Unknown error")")
          return
        }

        ProxyLogger.shared.log(message: "Intercepted data: \(data)")

        // Optionally modify the data here before forwarding
        // Example: tcpFlow.write(modifiedData)

        // Forward the data to its intended destination
        tcpFlow.write(data) { error in
          if let error = error {
            ProxyLogger.shared.log(error: "Failed to write data: \(error)")
          }
        }
      }
    }

    return true
  }
}

extension NEAppProxyProvider {

  fileprivate func logTCPRequest(with flowRequest: NEAppProxyTCPFlow) {
    ProxyLogger.shared.log(message: "logTCPRequest")
    if let remoteHost = (flowRequest.remoteEndpoint as? NWHostEndpoint)?.hostname {
      ProxyLogger.shared.log(message: "App ProxyProvider TCP HOST : \(remoteHost)")
    }
    if let remotePort = (flowRequest.remoteEndpoint as? NWHostEndpoint)?.port {
      ProxyLogger.shared.log(message: "App ProxyProvider TCP PORT : \(remotePort)")
    }
  }

  fileprivate func logUDPRequest(with flowRequest: NEAppProxyUDPFlow) {
    NSLog("logUDPRequest %@", flowRequest)

    if let localHost = (flowRequest.localEndpoint as? NWHostEndpoint)?.hostname {
      ProxyLogger.shared.log(message: "App ProxyProvider UDP HOST : \(localHost)")
    }
    if let localPort = (flowRequest.localEndpoint as? NWHostEndpoint)?.port {
      ProxyLogger.shared.log(message: "App ProxyProvider UDP PORT : \(localPort)")
    }
  }
}
