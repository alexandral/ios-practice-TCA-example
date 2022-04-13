//
//  FlexibleGridView.swift
//  places
//
//  Created by Alexandra Lovin on 10.04.2022.
//

import Foundation
import SwiftUI

struct FlexibleGridView<Data: Collection, Content: View>: View where Data.Element: Hashable {
  let availableWidth: CGFloat
  let data: Data
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  @State var elementsSize: [Data.Element: CGSize] = [:]

  var body: some View {
    VStack(alignment: alignment, spacing: spacing) {
      ForEach(computeRows(), id: \.self) { rowElements in
        HStack(spacing: spacing) {
          ForEach(rowElements, id: \.self) { element in
            content(element)
              .fixedSize()
              .readSize { size in
                elementsSize[element] = size
              }
          }
        }
      }
    }
  }

  func computeRows() -> [[Data.Element]] {
    Self.computeRows(data: data, availableWidth: availableWidth, spacing: spacing, elementsSize: elementsSize)
  }

  static func computeRows<Data: Collection>(data: Data, availableWidth: CGFloat, spacing: CGFloat, elementsSize: [Data.Element: CGSize]) -> [[Data.Element]] {
    var rows: [[Data.Element]] = [[]]
    var currentRow = 0
    var remainingWidth = availableWidth

    for element in data {
      let elementSize = elementsSize[element, default: CGSize(width: Self.sizeOfElementt(element, availableWidth: availableWidth, font: .body), height: 1)]

      if remainingWidth - (elementSize.width + spacing) >= 0 {
        rows[currentRow].append(element)
      } else {
        currentRow = currentRow + 1
        rows.append([element])
        remainingWidth = availableWidth
      }

      remainingWidth = remainingWidth - (elementSize.width + spacing)
    }

    return rows
  }

  static func sizeOfElementt<Element>(_ element: Element, availableWidth: CGFloat, font: Font) -> CGFloat {
    guard let string = element as? String else {
      return 0
    }
    let constraintRect = CGSize(width: availableWidth, height: 40)
    let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(from: font)], context: nil)
    return ceil(boundingBox.width)
  }
}
