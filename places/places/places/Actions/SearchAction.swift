//
//  Actions.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation

enum SearchAction: Equatable {
  case searchQueryChanged(String)
  case placeAutocompleteResponse(Result<[Place], Client.Failure>)
  case placeSelected(Place)
  case landmarkAction(LandmarkAction)
  case presentDetails(Bool)
}
