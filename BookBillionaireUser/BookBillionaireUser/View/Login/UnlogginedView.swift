//
//  UnlogginedView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/10/24.
//

import SwiftUI

struct UnlogginedView: View {
    @State private var isPresentedLogin: Bool = false
    var body: some View {
        VStack{
            Text("로그인이 필요한 서비스 입니다.")
            Button("로그인하기"){
                isPresentedLogin = true
            }
                .buttonStyle(WhiteButtonStyle(height: 40))
                .padding(.horizontal, 100)
        }.fullScreenCover(isPresented: $isPresentedLogin, content: {
            LoginView()
        })
        Button("로그아웃 하기"){
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
