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
            VStack {
                Spacer()
                Text("Book Billionaire")
                    .font(.title)
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
                    
                    HStack(spacing: 20) {
                        Spacer()
                        NavigationLink {
                            SignUpView()
                        } label: {
                            HStack {
                                Text("회원가입")
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        Spacer()
                        Button(action: {
                            signInProcessing = true
                            authViewModel.emailAuthLogIn(email: emailText, password: passwordText)
                        }) {
                            ZStack {
                                Text("로그인")
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(Color.accentColor)
                                    .background(emailText.isEmpty || passwordText.isEmpty == true ? .gray : .red)
                                    .cornerRadius(10)
                                
                                if signInProcessing {
                                    ProgressView()
                                }
                            }
                        }
                        .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                
                .padding(.horizontal, 50)
                Text("다른 방법으로 로그인")
                    .padding()
                Image("SignInWithGoogle")
                Spacer()
                Text("Team BB")
                SpaceBox()
            }
        }
    }
    
}

#Preview {
    LoginView()
}

