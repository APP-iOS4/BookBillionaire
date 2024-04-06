//
//  AccentButtonStyle.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/23/24.
//

import SwiftUI

struct AccentButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      ZStack{
          Capsule(style: .continuous)
              .foregroundColor(.accentColor)
              .frame(height: 40)
          configuration.label
              .padding()
              .foregroundColor(.white)
      }
  }
}

#Preview {
    Button("엑센트 버튼") {}
    .buttonStyle(AccentButtonStyle())
}
