//
//  LandmarksListView.swift
//  places
//
//  Created by Alexandra Lovin on 10.04.2022.
//

import SwiftUI
import ComposableArchitecture

struct LandmarksListView: View {
  let store: Store<LandmarksListState, LandmarkAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        GeometryReader { geometry in
          Spacer()
          List {
            ForEach(viewStore.landmarks, id: \.xid) { landmark in
              let padding: CGFloat = 8
              let extraSpace: CGFloat = 100
              let rows = FlexibleGridView<String, Self>.computeRows(data: landmark.tags, availableWidth: geometry.size.width - 2 * padding, spacing: padding, elementsSize: [:])
              LandmarkView(store: self.store, landmark: landmark, backgroundColor: .orange, textColor: .white, spacing: padding, padding: padding, cornerRadius: padding)
                .frame(height: extraSpace + (CGFloat(rows.count * 40) + padding))
            }
          }
          Spacer()
        }
        .navigationViewStyle(.stack)
        .onAppear { viewStore.send(.didAppear) }
      }
      .navigationTitle(viewStore.place.name)
      .font(.subheadline)
      .lineLimit(2)
    }
  }
}

struct LandmarksListView_Previews: PreviewProvider {
  static var previewView: some View {
    NavigationView {
      LandmarksListView(store: Store(
        initialState: LandmarksListState(place: .previewPlace, isLoading: false, landmarks: Landmark.previewLandmarks),
        reducer: .empty,
        environment: ()
      ))
    }
  }
  static var previews: some View {
    previewView
    previewView
      .preferredColorScheme(.dark)
  }
}
