//
//  Toast.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/12/24.
//

import SwiftUI

//struct Toast<Presenting>: View where Presenting: View {
//    @Binding var isShowing: Bool
//    let presenting: () -> Presenting
//    let text: Text
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .bottom) {
//                self.presenting()
//                VStack {
//                    self.text
//                }
//                .frame(width: geometry.size.width * 0.8, height: geometry.size.height / 10)
//                .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
//                .foregroundColor(Color.white)
//                .transition(.move(edge: .bottom))
//                .position(x: geometry.size.width / 2, y: self.isShowing ? geometry.size.height - geometry.size.height / 10 - geometry.size.height / 20 : geometry.size.height + geometry.size.height / 5)
//            }
//        }
//    }
//}

struct Toast<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    let text: Text

    var body: some View {
        ZStack(alignment: .bottom) {
            self.presenting()
            VStack {
                self.text
            }
            .frame(width: 300, height: 50)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
            .foregroundColor(Color.white)
            .offset(y: self.isShowing ? 0 : 300)
            .opacity(self.isShowing ? 1 : 0)
        }
        .onChange(of: isShowing) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isShowing = newValue
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing, presenting: { self }, text: text)
    }
}
