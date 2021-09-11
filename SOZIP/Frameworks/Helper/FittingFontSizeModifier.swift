//
//  FittingFontSizeModifier.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI

struct FittingFontSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 100))
      .minimumScaleFactor(0.001)
  }
}
