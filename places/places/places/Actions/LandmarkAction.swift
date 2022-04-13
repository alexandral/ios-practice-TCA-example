//
//  LandmarkAction.swift
//  places
//
//  Created by Alexandra Lovin on 11.04.2022.
//

import Foundation
enum LandmarkAction: Equatable {
  case didAppear
  case loadFavouritesFromDatabase
  case landmarksResponse(Result<[Landmark], Client.Failure>)
  case databaseLoaded([Landmark])
  case toggleFavorite(Landmark)
  case saveLandmarkToDatabase(Landmark)
  case saveToDatabaseResult(Result<Signal, DatabaseError>)
}
