//
//  placesApp.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct placesApp: App {

  let store: Store<AppState, AppAction> = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment.live)
  
  var body: some Scene {
    WindowGroup {
      WithViewStore(self.store.scope(state: AppViewState.init(state:))) { viewStore in
        NavigationView {
          PlacesListView(store: self.store.scope(
            state: \.placeState,
            action: AppAction.search
          ))
        }
      }
    }
  }
}
