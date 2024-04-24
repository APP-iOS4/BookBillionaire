//
//  LoginView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/22/24.
//

import SwiftUI

struct LoginView: View {
    @State private var inputID: String = ""
    @State private var inputPassword: String = ""
    var body: some View {
        HStack{
            VStack {
                Image("logoShortCut")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200,alignment: .center)
                Image("mainPageLogo")
                    .resizable()
                    .scaledToFit()
            }
            .padding(.leading, 50)
            Spacer(minLength: 100)
            VStack(alignment: .leading) {
                Text("로그인")
                    .font(.title).bold().foregroundStyle(.bbfont)
                TextField("   아이디", text: $inputID)
                    .padding()
                    .background(.clear)
                    .border(Color.accentColor)
                    .textInputAutocapitalization(.never)
                TextField("   비밀번호", text: $inputPassword)
                    .padding()
                    .background(.clear)
                    .border(Color.accentColor)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical)
                Button("로그인") {
                }.buttonStyle(AccentButtonStyle())
            }
            .padding(.horizontal, 100)
        }
    }
}

#Preview {
    LoginView()
}
