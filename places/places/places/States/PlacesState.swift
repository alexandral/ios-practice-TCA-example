//
//  PlacesState.swift
//  places
//
//  Created by Alexandra Lovin on 11.04.2022.
//

import Foundation
struct PlacesState: Equatable {
  var query: String = ""
  var places: [Place]
  var selectedPlace: Place?
  var landmarkState: LandmarksListState?
}

extension PlacesState {
  init() {
    self.places = []
    self.landmarkState = nil
    self.selectedPlace = nil
  }
}
