//
//  AccentButtonStyle.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/23/24.
//

import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    var height: CGFloat = 60
    var font: Double = 20
  func makeBody(configuration: Configuration) -> some View {
      ZStack{
          Capsule(style: .continuous)
              .foregroundColor(.accentColor)
              .frame(height: self.height)
          configuration.label
              .padding()
              .foregroundColor(.white)
              .font(.system(size: font))
      }
  }
}

#Preview {
    Button("엑센트 버튼") {}
    .buttonStyle(AccentButtonStyle())
}
