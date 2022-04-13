//
//  PlacesState.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation
import SwiftUI

struct AppState: Equatable {
  var placeState: PlacesState
  var isRunningTests: Bool = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil

  init() {
    self.placeState = PlacesState()
  }
}


struct AppViewState: Equatable {
  let isPresentingUI: Bool
  init(state: AppState) {
    isPresentingUI = state.isRunningTests == false
  }
}
