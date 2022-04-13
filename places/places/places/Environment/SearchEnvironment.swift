//
//  SearchEnvironment.swift
//  places
//
//  Created by Alexandra Lovin on 12.04.2022.
//

import Foundation
import ComposableArchitecture
import RealmSwift

struct SearchEnvironment {
  let realm: Realm?
  let queryDebounceInterval: DispatchQueue.SchedulerTimeType.Stride = 0.25
  var client: Client
  var mainQueue: AnySchedulerOf<DispatchQueue>

  init(client: Client, realm: Realm?, mainQueue: AnySchedulerOf<DispatchQueue>) {
    self.realm = realm
    self.client = client
    self.mainQueue = mainQueue
  }
}

extension SearchEnvironment {
  static func live(realm: Realm) -> SearchEnvironment {
    SearchEnvironment(client: .live, realm: realm, mainQueue: .main)
  }
  static let failing = SearchEnvironment(client: .failing, realm: nil, mainQueue: .main)
}
