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
        Button{
            isShowingLoginSheet = true
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10.0)
                    .frame(height: 100)
                    .foregroundStyle(.thinMaterial)
                HStack{
                    Image("defaultUser1")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text("로그인하고 같이 책읽으러 가기")
                        .tint(.accentColor)
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingLoginSheet, content: {
            LoginView()
        })
    }

}

#Preview {
    UnlogginedView()
}
