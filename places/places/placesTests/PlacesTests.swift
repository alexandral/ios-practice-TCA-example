//
//  PlacesTests.swift
//  places
//
//  Created by Alexandra Lovin on 11.04.2022.
//

import XCTest
import ComposableArchitecture
@testable import places

final class PlacesTests: XCTestCase {

  private let testScheduler = DispatchQueue.test
  private lazy var testEnvironment = SearchEnvironment(client: .test, realm: nil, mainQueue: self.testScheduler.eraseToAnyScheduler())

  func testNotPresentingUIWhileTesting() {
    let state = AppState()
    let viewState = AppViewState(state: state)
    XCTAssertFalse(viewState.isPresentingUI)
  }

  func testAutocompleteSearchAction() {
    let store = TestStore(
      initialState: PlacesState(),
      reducer: searchReducer,
      environment: testEnvironment)

    let query = "Buc"
    let testPlaces = Place.testPlaces

    store.send(.searchQueryChanged(query)) {
      $0.query = query
    }
    testScheduler.advance(by: testEnvironment.queryDebounceInterval)
    store.receive(.placeAutocompleteResponse(.success(testPlaces))) {
      $0.query = query
      $0.places = testPlaces
    }
  }

  func testLandmarkResponseAction() {
    let store = TestStore(
      initialState: PlacesState(),
      reducer: searchReducer,
      environment: testEnvironment)
    let selectedPlace = Place.testSelectedPlace
    store.send(.placeSelected(selectedPlace)) {
      $0.selectedPlace = selectedPlace
      $0.landmarkState = LandmarksListState(place: selectedPlace, isLoading: true, landmarks: [])
    }
    testScheduler.advance()
  }

  func testPresentDetails() {
    let store = TestStore(
      initialState: PlacesState(),
      reducer: searchReducer,
      environment: testEnvironment)
    let selectedPlace = Place.testSelectedPlace
    store.send(.placeSelected(selectedPlace)) {
      $0.selectedPlace = selectedPlace
      $0.landmarkState = LandmarksListState(place: selectedPlace, isLoading: true, landmarks: [])
    }
    testScheduler.advance()
    store.send(.presentDetails(true)) {
      $0.selectedPlace = selectedPlace
    }
    testScheduler.advance()
    store.send(.presentDetails(false)) {
      $0.selectedPlace = nil
      $0.landmarkState = nil
    }
  }
}

extension Client {
  static func testPlaceAutocompleteEffect() -> Effect<[Place], Client.Failure> {
    Effect(value: Place.testPlaces)
  }
  static func testLandmarkResponseEffect() -> Effect<[Landmark], Client.Failure> {
    Effect(value: Landmark.testLandmarks)
  }
  static let test = Client(
    searchByName: { query in
      Self.testPlaceAutocompleteEffect()
    },
    searchLandmarks: { parameters in
      Self.testLandmarkResponseEffect()
    }
  )
}
