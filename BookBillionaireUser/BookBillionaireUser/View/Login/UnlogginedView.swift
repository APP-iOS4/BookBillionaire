//
//  UnlogginedView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/10/24.
//

import SwiftUI

struct UnlogginedView: View {
    @State private var isPresentedLogin: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.state == .loggedOut {
            VStack{
                Text("로그인이 필요한 서비스 입니다.")
                Button("로그인하기"){
                    isPresentedLogin = true
                }
                .buttonStyle(WhiteButtonStyle(height: 40))
                .padding(.horizontal, 100)
            }
            .fullScreenCover(isPresented: $isPresentedLogin, content: {
                LoginView(isPresentedLogin: $isPresentedLogin)
            })
        } else {
            VStack {
                Button("로그아웃하기"){
                    authViewModel.signOut()
                }
                .buttonStyle(WhiteButtonStyle(height: 40))
                .padding(.horizontal, 100)
            }
        }
    }

}

#Preview {
    UnlogginedView()
}
