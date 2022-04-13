//
//  Environment.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation
import ComposableArchitecture
import RealmSwift

struct AppEnvironment {
  static let realm: Realm = try! Realm()
  let searchEnvironment: SearchEnvironment

  init(searchEnvironment: SearchEnvironment) {
    self.searchEnvironment = searchEnvironment
  }
}

extension AppEnvironment {
  static let live = AppEnvironment(searchEnvironment: .live(realm: realm))
  static let failing = AppEnvironment(searchEnvironment: .failing)
}
