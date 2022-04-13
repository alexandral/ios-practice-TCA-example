//
//  PlaceClient.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation
import ComposableArchitecture

struct LandmarkListQuery {
  let lat: Double
  let lon: Double
  let offset: Int
  let limit: Int
}

struct Client {
  static let decoder = JSONDecoder()
  var searchByName: (String) -> Effect<[Place], Failure>
  var searchLandmarks: (LandmarkListQuery) -> Effect<[Landmark], Failure>
  enum Failure: Error, Equatable {
    case api(String)
    case decoder(String)
  }
}

extension Client {
  static let live = Client(
    searchByName: { query in
      guard let query = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
            let url = URL(string: "https://api.geoapify.com/v1/geocode/autocomplete?apiKey=\(APIKey.geoapify.rawValue)&limit=10&text=\(query)") else {
              return Effect.init(value: [])
            }
      return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { error in Failure.api(error.localizedDescription) }
        .map { data, _ in data }
        .decode(type: PlaceResponse.self, decoder: decoder)
        .map { $0.places }
        .mapError { error in Failure.decoder(error.localizedDescription) }
        .eraseToEffect()
    },
    searchLandmarks: { parameters in
      guard let url = URL(string: "https://api.opentripmap.com/0.1/en/places/radius?apikey=\(APIKey.openAPI.rawValue)&radius=1000&limit=\(parameters.limit)&offset=\(parameters.offset)&lon=\(parameters.lon)&lat=\(parameters.lat)&format=json") else {
        return Effect.init(value: [])
      }
      return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { error in Failure.api(error.localizedDescription) }
        .map { data, _ in data }
        .decode(type: [Landmark].self, decoder: decoder)
        .mapError { error in Failure.decoder(error.localizedDescription) }
        .eraseToEffect()
    }
  )
}

#if DEBUG
  extension Client {
    public static let failing = Self(
      searchByName: { _ in .failing("Client.searchByName") },
      searchLandmarks: { _ in .failing("Client.searchLandmarks") }
    )
  }
#endif
