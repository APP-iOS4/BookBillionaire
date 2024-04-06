//
//  WhiteButtonStyle.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/23/24.
//

import SwiftUI

struct WhiteButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
      ZStack{
          Capsule(style: .continuous)
              .stroke(Color.accentColor)
              .foregroundColor(.white)
              .frame(height: 40)
          configuration.label
              .padding()
              .foregroundColor(.accentColor)
      }
  }
}

#Preview {
    Button("하얀색 버튼") {}
    .buttonStyle(WhiteButtonStyle())
}
