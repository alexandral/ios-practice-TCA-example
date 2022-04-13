//
//  Place.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation

struct PlaceResponse: Decodable, Equatable {
  let places: [Place]
  enum CodingKeys: String, CodingKey {
    case places = "features"
  }
}

struct Place: Decodable, Equatable {
  let name: String
  let country: String?
  let lon: Double
  let lat: Double

  enum CodingKeys: String, CodingKey {
    case properties
    enum Place: String, CodingKey {
      case name, country, formatted, lon, lat, city
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let cityContainer = try container.nestedContainer(keyedBy: CodingKeys.Place.self, forKey: .properties)
    let formatted = try cityContainer.decode(String.self, forKey: CodingKeys.Place.formatted)
    self.name = formatted
    self.country = try? cityContainer.decode(String.self, forKey: CodingKeys.Place.country)
    self.lon = try cityContainer.decode(Double.self, forKey: CodingKeys.Place.lon)
    self.lat = try cityContainer.decode(Double.self, forKey: CodingKeys.Place.lat)
  }
}

extension Place {
  init(name: String, lon: Double, lat: Double) {
    self.name = name
    self.lon = lon
    self.lat = lat
    self.country = nil
  }
}
