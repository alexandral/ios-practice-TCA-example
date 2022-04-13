//
//  Landmark.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//
import Foundation

// MARK: - Landmark
struct Landmark: Decodable, Equatable {
  let xid, name: String
  let rate: Int
  let wikipediaExtracts: WikipediaExtracts?
  let tags: [String]
  var isFavorite: Bool = false

  enum CodingKeys: String, CodingKey {
    case xid, name, rate
    case tags = "kinds"
    case wikipediaExtracts = "wikipedia_extracts"
  }

  static func == (lhs: Landmark, rhs: Landmark) -> Bool {
    lhs.xid == rhs.xid
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.xid = try container.decode(String.self, forKey: .xid)
    self.rate = try container.decode(Int.self, forKey: .rate)
    self.wikipediaExtracts = try? container.decode(WikipediaExtracts.self, forKey: .wikipediaExtracts)
    self.tags = try container.decode(String.self, forKey: .tags)
      .components(separatedBy: ",")
      .compactMap { $0.replacingOccurrences(of: "_", with: " ")}
  }
}

extension Landmark {
  init(xid: String, name: String, rate: Int, wikipediaExtracts: WikipediaExtracts?, tags: [String], isFavorite: Bool = false) {
    self.xid = xid
    self.name = name
    self.rate = rate
    self.wikipediaExtracts = wikipediaExtracts
    self.tags = tags
    self.isFavorite = isFavorite
  }
  var dbObject: LandmarkObject {
    .init(value: dbValues)
  }
  var dbValues: [String: Any] {
    ["xid": xid, "isFavorite": isFavorite, "name": name, "tags": tags, "rate": rate]
  }
}

// MARK: - WikipediaExtracts
struct WikipediaExtracts: Codable {
  let title, text, html: String
}
