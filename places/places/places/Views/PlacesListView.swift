//
//  PlacesListView.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct PlacesListView: View {
  let store: Store<PlacesState, SearchAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading) {

        HStack {
          Image(systemName: "magnifyingglass")
          TextField(
            "Search by a place name",
            text: viewStore.binding(
              get: \.query, send: SearchAction.searchQueryChanged
            )
          )
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)

        LazyVStack {
          ForEach(viewStore.places, id: \.name) { place in
            VStack(alignment: .leading) {
              Button(action: {
                viewStore.send(.placeSelected(place))
                viewStore.send(.presentDetails(true))
              }) {
                HStack {
                  Text(place.name)
                }
              }
            }
          }
        }
      }
      .navigate(
        using: store.scope(
          state: \.landmarkState,
          action: SearchAction.landmarkAction
        ),
        destination: LandmarksListView.init(store:),
        onDismiss: {
          ViewStore(store.stateless).send(.presentDetails(false))
        }
      )
    }
  }
}


struct PlacesListView_Previews: PreviewProvider {

  static var previewView: some View {
    PlacesListView(store: Store(
      initialState: PlacesState(query: "Buc", places: Place.previewPlaces, selectedPlace: nil, landmarkState: nil),
      reducer: .empty,
      environment: ()
    ))
  }

  static var previews: some View {
    previewView
    previewView
      .preferredColorScheme(.dark)
  }
}
