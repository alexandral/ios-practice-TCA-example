//
//  Realm+.swift
//  Notas
//
//  Created by Dscyre Scotti on 19/07/2021.
//

import RealmSwift
import Foundation
import Combine
import ComposableArchitecture

extension Realm {
  func fetch<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Effect<Results<T>, Never> {
    let promise = Future<Results<T>, Never> { completion in
      let objects = self.objects(type)
      if let predicate = predicate {
        completion(.success(objects.filter(predicate)))
        return
      }
      completion(.success(objects))
    }
    return promise.eraseToEffect()
  }

  func save<T: Object>(_ type: T.Type, value: [String: Any]) -> Effect<Signal, DatabaseError> {
    let promise = Future<Signal, DatabaseError> { completion in
      do {
        try self.write {
          self.create(type, value: value, update: .modified)
        }
        completion(.success(.signal))
      } catch {
        completion(.failure(DatabaseError.unableToSave(error.localizedDescription)))
      }
    }
    return promise.eraseToEffect()
  }

  func save<T: Object>(_ object: T) -> Effect<Signal, DatabaseError> {
    let promise = Future<Signal, DatabaseError> { completion in
      do {
        try self.write {
          self.create(T.self, value: object, update: .modified)
        }
        completion(.success(.signal))
      } catch {
        completion(.failure(DatabaseError.unableToSave(error.localizedDescription)))
      }
    }
    return promise.eraseToEffect()
  }

  func create<T: Object>(_ type: T.Type, object: T) -> Effect<Signal, DatabaseError> {
    let promise = Future<Signal, DatabaseError> { completion in
      do {
        try self.write({
          self.add(object)
        })
        completion(.success(.signal))
      } catch {
        completion(.failure(DatabaseError.unableToCreate))
      }
    }
    return promise.eraseToEffect()
  }

  func delete<T: Object>(_ type: T.Type, id: UUID) -> Effect<Signal, DatabaseError> {
    let promise = Future<Signal, DatabaseError> { completion in
      do {
        try self.write {
          self.delete(self.objects(type).filter("id == %@", id))
        }
        completion(.success(.signal))
      } catch {
        completion(.failure(DatabaseError.unableToDelete))
      }
    }
    return promise.eraseToEffect()
  }
}

struct Signal: Equatable { }

extension Signal {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return true
  }

  static var signal: Self {
    Self()
  }
}
