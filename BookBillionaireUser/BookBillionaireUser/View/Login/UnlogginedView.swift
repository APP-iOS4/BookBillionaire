//
//  UnlogginedView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/9/24.
//

import SwiftUI

struct UnlogginedView: View {
    @State private var isPresentedSheet: Bool = false
    var body: some View {
        Text("로그인이 필요한 서비스입니다.")
        Button("로그인 하기"){
            isPresentedSheet = true
        }.buttonStyle(WhiteButtonStyle(height: 40))
            .padding(40)
        .fullScreenCover(isPresented: $isPresentedSheet, content: {
            LoginView()
        })
    }
}

#Preview {
    UnlogginedView()
}
