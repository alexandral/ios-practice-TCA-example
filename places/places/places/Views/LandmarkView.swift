//
//  LandmarkView.swift
//  places
//
//  Created by Alexandra Lovin on 03.04.2022.
//

import SwiftUI
import ComposableArchitecture

struct LandmarkView: View {
  let store: Store<LandmarksListState, LandmarkAction>
  let landmark: Landmark
  let backgroundColor: Color
  let textColor: Color
  let spacing: CGFloat
  let padding: CGFloat
  let cornerRadius: CGFloat
  var body: some View {
    WithViewStore(self.store) { viewStore in
      GeometryReader { geometry in
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Text(verbatim: landmark.name)
              .font(.body)
              .lineLimit(2)
            Spacer()
            Button {
              viewStore.send(.toggleFavorite(landmark))
            } label: {
              Image(systemName: viewStore.favoriteIds.contains(landmark.xid) ? "heart.fill" : "heart")
                .foregroundColor(.orange)
            }
            .frame(width: 30, height: 30)
          }
          Spacer()
          FlexibleGridView(availableWidth: geometry.size.width - 2 * padding, data: landmark.tags, spacing: spacing, alignment: .leading) { tag in
            Text(verbatim: tag)
              .padding(padding)
              .font(.body)
              .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                  .fill(backgroundColor)
              ).foregroundColor(textColor)
          }
          Spacer()
        }
      }
    }
  }
}

struct LandmarkView_Previews: PreviewProvider {

  static var previewView: some View {
    LandmarkView(store: Store(
      initialState: LandmarksListState(place: Place.previewPlace, isLoading: false, landmarks: Landmark.previewLandmarks),
      reducer: .empty,
      environment: ()
    ), landmark: .previewLandmark, backgroundColor: .orange, textColor: .white, spacing: 8, padding: 8, cornerRadius: 8)
  }

  static var previews: some View {
    previewView
    previewView
      .preferredColorScheme(.dark)
  }
}
