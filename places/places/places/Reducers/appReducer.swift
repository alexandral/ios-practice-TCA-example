//
//  AppState.swift
//  places
//
//  Created by Alexandra Lovin on 11.04.2022.
//

import Foundation
import ComposableArchitecture

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
  searchReducer.pullback(
    state: \.placeState,
    action: /AppAction.search,
    environment: { $0.searchEnvironment }
  )
)
