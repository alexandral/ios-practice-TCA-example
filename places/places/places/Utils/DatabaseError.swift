//
//  DatabaseError.swift
//  places
//
//  Created by Alexandra Lovin on 12.04.2022.
//

import Foundation
enum DatabaseError: Error {
  case unableToSave(String)
  case unableToCreate
  case unableToDelete
  case unknown
}

extension DatabaseError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .unableToSave(errorMessage):
      return errorMessage
    case .unableToCreate:
      return NSLocalizedString("Unable to create an object.", comment: "")
    case .unableToDelete:
      return NSLocalizedString("Unable to delete the object.", comment: "")
    case .unknown:
      return NSLocalizedString("Unknown error.", comment: "")
    }
  }
}

extension DatabaseError: Equatable { }
