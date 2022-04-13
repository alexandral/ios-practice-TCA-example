//
//  LandmarksListState.swift
//  places
//
//  Created by Alexandra Lovin on 11.04.2022.
//

import Foundation
struct LandmarksListState: Equatable {
  var place: Place
  var isLoading: Bool
  var landmarks: [Landmark]
  var favoriteIds: Set<String> = []
}
