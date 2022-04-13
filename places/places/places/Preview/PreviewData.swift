//
//  PreviewData.swift
//  places
//
//  Created by Alexandra Lovin on 10.04.2022.
//

import Foundation

extension Place {
  static let previewPlace: Place = Place(name: "New York", lon: 1, lat: 1)
  static let testSelectedPlace: Place = Place(name: "Bucharest", lon: 1, lat: 1)
  static let testPlaces: [Place] = [testSelectedPlace, Place(name: "Budapesta", lon: 1, lat: 1)]
  static let previewPlaces: [Place] = [testSelectedPlace, Place(name: "Budapesta", lon: 1, lat: 1)]
}

extension Landmark {
  static let previewLandmark: Landmark = Landmark(xid: "1", name: "The Metroplitan Museum of Art", rate: 4, wikipediaExtracts: nil, tags: ["art", "museum", "landmarks", "historic architecture", "tourist facilities", "skyscrapers"])
  static let previewLandmarks: [Landmark] = Array.init(repeating: Self.previewLandmark, count: 5)
  static let testLandmarks: [Landmark] = Array.init(repeating: Self.previewLandmark, count: 5)
}
