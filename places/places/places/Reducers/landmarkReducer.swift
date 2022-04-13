//
//  Reducers.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation
import ComposableArchitecture
import RealmSwift

let landmarkReducer = Reducer<LandmarksListState, LandmarkAction, SearchEnvironment> {
  state, action, environment in
  switch action {
  case .didAppear:
    return handleLoadFromAPI(state: &state, environment: environment)
  case let .landmarksResponse(.failure(failure)):
    state.landmarks.removeAll()
    state.isLoading = false
  case let .landmarksResponse(.success(landmarks)):
    state.isLoading = false
    state.landmarks = landmarks
    return .init(value: .loadFavouritesFromDatabase)
  case .loadFavouritesFromDatabase:
    return handleLoadFavouritesFromDatabase(state: &state, environment: environment)
  case .databaseLoaded(let localLandmarks):
    return handleDataBaseLoaded(localLandmarks: localLandmarks, state: &state, environment: environment)
  case .saveLandmarkToDatabase(let landmark):
    return save(landmark: landmark, state: &state, environment: environment)
  case .toggleFavorite(let landmark):
    return handleToggleFavourite(landmark: landmark, state: &state, environment: environment)
  case let .saveToDatabaseResult(.success(dbResult)):
    print("Did save with success")
  case let .saveToDatabaseResult(.failure(dbError)):
    print("Did save with error \(dbError)")
  }
  return .none
}.debugActions()

private func handleLoadFromAPI(state: inout LandmarksListState, environment: SearchEnvironment) -> Effect<LandmarkAction, Never> {
  let landmarkQuery = LandmarkListQuery(lat: state.place.lat, lon: state.place.lon, offset: state.landmarks.count, limit: 10)
  return environment.client
    .searchLandmarks(landmarkQuery)
    .receive(on: environment.mainQueue)
    .catchToEffect(LandmarkAction.landmarksResponse)
}

private func handleLoadFavouritesFromDatabase(state: inout LandmarksListState, environment: SearchEnvironment) -> Effect<LandmarkAction, Never> {
  guard let realm = environment.realm else {
    return .none
  }
  return realm
    .fetch(LandmarkObject.self, predicate: NSPredicate(format: "isFavorite == %@", NSNumber(true)))
    .map { results -> LandmarkAction in
      let dbLandmarks = Array(results.compactMap { $0.landmark })
      return .databaseLoaded(dbLandmarks)
    }
    .eraseToEffect()
}

private func handleDataBaseLoaded(localLandmarks: [Landmark], state: inout LandmarksListState, environment: SearchEnvironment) -> Effect<LandmarkAction, Never> {
  let updatedLandmarks: [Landmark] = state.landmarks.map { landmark in
    if let localLandmark = localLandmarks.first(where: { $0.xid == landmark.xid }) {
      var updatedLandmark = landmark
      updatedLandmark.isFavorite = localLandmark.isFavorite
      return updatedLandmark
    } else {
      return landmark
    }
  }
  state.favoriteIds = Set(localLandmarks
    .filter { $0.isFavorite }
    .compactMap { $0.xid })
  state.landmarks = updatedLandmarks
  return .none
}

private func save(landmark: Landmark, state: inout LandmarksListState, environment: SearchEnvironment) -> Effect<LandmarkAction, Never> {
  guard let realm = environment.realm else {
    return .none
  }
  return realm
    .create(LandmarkObject.self, object: landmark.dbObject)
    .catchToEffect()
    .map { LandmarkAction.saveToDatabaseResult($0) }
    .eraseToEffect()
}

private func handleToggleFavourite(landmark: Landmark, state: inout LandmarksListState, environment: SearchEnvironment) -> Effect<LandmarkAction, Never> {
  guard let realm = environment.realm else {
    return .none
  }
  let isFavorite = !landmark.isFavorite
  let updatedLandmarks: [Landmark] = state.landmarks.map {
    if $0.xid == landmark.xid {
      var landmark = $0
      landmark.isFavorite = isFavorite
      return landmark
    }
    return $0
  }
  var updatedLandmark = landmark
  updatedLandmark.isFavorite = isFavorite
  state.landmarks = updatedLandmarks
  if state.favoriteIds.contains(landmark.xid) {
    state.favoriteIds.remove(landmark.xid)
  } else {
    state.favoriteIds.insert(landmark.xid)
  }
  return realm
    .save(LandmarkObject.self, value: updatedLandmark.dbValues)
    .catchToEffect()
    .map { LandmarkAction.saveToDatabaseResult($0) }
    .eraseToEffect()
}
