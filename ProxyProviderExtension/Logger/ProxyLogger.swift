//
//  ProxyLogger.swift
//  Kahf
//
//  Created by Mohammed Rokon Uddin on 10/10/24.
//

import Foundation
import os

class ProxyLogger {

  // MARK: Shared Instance

  static let shared = ProxyLogger()
  private let logger: Logger

  // MARK: Init

  private init() {
    let identifier = Bundle.main.bundleIdentifier ?? "AppProxySystem"

    logger = Logger(subsystem: identifier, category: "AppLogging")
  }

  // MARK: Functions

  func log(message value: String) {
    logger.log("message \(value, privacy: .public)")

  }

  func log(error value: String) {
    logger.error("error: \(value, privacy: .public)")
  }
}
