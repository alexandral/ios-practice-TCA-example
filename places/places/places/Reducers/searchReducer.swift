//
//  searchReducer.swift
//  places
//
//  Created by Alexandra Lovin on 10.04.2022.
//

import Foundation
import ComposableArchitecture

let searchReducer = Reducer<PlacesState, SearchAction, SearchEnvironment> {
  state, action, environment in
  switch action {
  case .searchQueryChanged(let query):
    return handleSearchQueryChanged(query, state: &state, environment: environment)
  case let .placeAutocompleteResponse(.failure(failure)):
    state.places.removeAll()
  case let .placeAutocompleteResponse(.success(places)):
    state.places = places
  case .placeSelected(let place):
    let landmarkState = LandmarksListState(place: place, isLoading: true, landmarks: [])
    state.selectedPlace = place
    state.landmarkState = landmarkState
  case .landmarkAction(let landmarkAction):
    break
  case .presentDetails(let how):
    if !how {
      state.landmarkState = nil
      state.selectedPlace = nil
    }
  }
  return .none
}.presents(
  landmarkReducer,
  state: \.landmarkState,
  action: /SearchAction.landmarkAction,
  environment: { $0 }
)
  .debugActions()


private func handleSearchQueryChanged(_ query: String, state: inout PlacesState, environment: SearchEnvironment) -> Effect<SearchAction, Never> {
  struct SearchId: Hashable {}
  state.query = query
  guard !query.isEmpty else {
    state.places.removeAll()
    state.selectedPlace = nil
    state.landmarkState = nil
    return .none
  }
  state.query = query
  return environment.client
    .searchByName(query)
    .debounce(id: SearchId(), for: environment.queryDebounceInterval, scheduler: environment.mainQueue)
    .catchToEffect(SearchAction.placeAutocompleteResponse)
}
