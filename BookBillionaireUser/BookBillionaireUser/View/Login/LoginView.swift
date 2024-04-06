//
//  Login.swift
//  BookBillionaire
//
//  Created by Seungjae Yu on 3/20/24.
//

import SwiftUI

struct LoginView: View {
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var signInProcessing: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Spacer()
            VStack {
                Text("Book Billionaire")
                    .font(.title)
                ZStack {
                    VStack(spacing: 20) {
                        TextField("email", text: $emailText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                            .foregroundColor(Color.accentColor)
                            .padding(.top, 50)
                            .textInputAutocapitalization(.none)
                            .autocapitalization(.none)
                        SecureField("Password", text: $passwordText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                            .foregroundColor(Color.accentColor)
                        
                        HStack(spacing: 5) {
                            NavigationLink("회원가입") {
                                SignUpView()
                            }.buttonStyle(WhiteButtonStyle(height: 50))
                            Spacer()
                            Button("로그인"){
                                signInProcessing = true
                                authViewModel.emailAuthLogIn(email: emailText, password: passwordText)
                            }.buttonStyle(WhiteButtonStyle(height: 50))
                                .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                            
                            //                            ZStack {
                            //                                Text("로그인")
                            //                                    .padding()
                            //                                    .background(emailText.isEmpty || passwordText.isEmpty == true ? .gray : .red)
                            //
                            
                        }
                        .padding()
                        Text("다른 방법으로 로그인")
                            .padding()
                        Image("SignInWithGoogle")
                        //}
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
//                    if signInProcessing {
//                        ProgressView()
//                    }
                }
            }
            Spacer()
            Text("Team BB")
            SpaceBox()
        }
    }
    
    
}

#Preview {
    LoginView()
}

