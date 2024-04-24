//
//  Button.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/21/24.
//

import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    var height: CGFloat = 50
    var font: Font? = .system(size: 20)
  func makeBody(configuration: Configuration) -> some View {
      ZStack{
          RoundedRectangle(cornerRadius: 10.0)
              .foregroundColor(.accentColor)
              .frame(height: self.height)
          configuration.label
              .padding()
              .foregroundColor(.black)
              .font(font)
      }
  }
}

#Preview {
    Button("엑센트 버튼") {}
    .buttonStyle(AccentButtonStyle())
}
