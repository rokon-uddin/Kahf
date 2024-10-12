//
//  ProxyManager.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/11/24.
//

import Foundation
import NetworkExtension

class ProxyManager {
  private let manager = NETunnelProviderManager()

  func enable(privacy: PrivacyLevel) {
    loadAndUpdatePreferences { [weak self] in
      guard let `self` = self else { return }

      let configuration = NETunnelProviderProtocol()
      configuration.providerBundleIdentifier = Constants.protocolIdentifier
      configuration.serverAddress = privacy.rawValue.lowercased() + Constants.dnsUrl

      self.manager.protocolConfiguration = configuration
      self.manager.localizedDescription = Constants.localizedDescription
      self.manager.isEnabled = true

      do {
        try manager.connection.startVPNTunnel()
        ProxyLogger.shared.log(message: "VPN Tunnel started successfully")
      } catch {
        ProxyLogger.shared.log(error: "Error starting VPN Tunnel: \(error)")
      }
    }
  }

  func disable() {
    loadAndUpdatePreferences { [weak self] in
      guard let `self` = self else { return }
      self.manager.isEnabled = false
      self.manager.connection.stopVPNTunnel()
    }
  }

  // MARK: Private Functions
  private func loadAndUpdatePreferences(_ completion: @escaping () -> Void) {
    manager.loadFromPreferences { [weak self] error in
      guard error == nil else {
        ProxyLogger.shared.log(error: "Kahf.App: load error")
        return
      }

      self?.manager.saveToPreferences { (error) in
        guard error == nil else {
          ProxyLogger.shared.log(error: "Kahf.App: save error")
          completion()
          return
        }
        completion()
        ProxyLogger.shared.log(message: "Kahf.App: saved")
      }
    }
  }
}
