//
//  LandmarkObject.swift
//  places
//
//  Created by Alexandra Lovin on 12.04.2022.
//

import Foundation
import RealmSwift

class LandmarkObject: Object {
  @Persisted(primaryKey: true) var xid: String
  @Persisted var name: String
  @Persisted var rate: Int
  @Persisted var isFavorite: Bool
}

extension LandmarkObject {
  var landmark: Landmark {
    .init(xid: xid, name: name, rate: rate, wikipediaExtracts: nil, tags: [], isFavorite: isFavorite)
  }
}
