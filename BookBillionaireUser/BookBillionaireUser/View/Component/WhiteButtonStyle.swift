//
//  WhiteButtonStyle.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/23/24.
//

import SwiftUI

struct WhiteButtonStyle: ButtonStyle {
    var height: CGFloat = 60
    var font: Font? = .system(size: 20)
  func makeBody(configuration: Configuration) -> some View {
      ZStack{
          Capsule(style: .continuous)
              .stroke(Color.accentColor)
              .foregroundStyle(.white)
              .frame(height: self.height)
          configuration.label
              .padding()
              .foregroundColor(.accentColor)
              .font(font)
      }
  }
}

#Preview {
    Button("하얀색 버튼") {}
    .buttonStyle(WhiteButtonStyle())
}
