//
//  UnlogginedView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/10/24.
//

import SwiftUI

struct UnlogginedView: View {
    @State private var isShowingLoginSheet: Bool = false
    var body: some View {
        VStack{
            Text("당신의 책을 공유하세요")
                .padding(.top, 10)
                .font(.title2).bold()
                .foregroundStyle(.bbfont)
            Image("AppLogo")
                .resizable()
                .scaledToFit()
            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundStyle(Color.accentColor)
                    .padding()
                    .padding(.top, 150)
                    .padding(.bottom, -20)
            }
            Button{
                isShowingLoginSheet = true
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0)
                        .frame(height: 80)
                        .foregroundStyle(.thinMaterial)
                        .padding()
                    HStack{
                        Image("defaultUser2")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text("로그인하고 같이 책읽으러 가기")
                            .tint(.bbfont)
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingLoginSheet, content: {
                LoginView(isPresentedLogin: $isShowingLoginSheet)
            })
        }
    }

}

#Preview {
    UnlogginedView()
}
