//
//  RLoginView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/13/24.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct RLoginView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var authViewModelGoogle: AuthViewModelGoogle
    @Environment (\.dismiss) private var dismiss

    @Binding var isPresentedLogin: Bool
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State private var isSignUpScreen: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                // 앱로고
                Section{
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.top, 100)
                
                // 로그인 입력창
                Section {
                    VStack(spacing: 10) {
                        TextField("email", text: $emailText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $passwordText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                    }
                }
                .padding(.top, 50)
            
                HStack(spacing: 20) {
                    Button("회원가입") {
                        isSignUpScreen = true
                    }
                    .buttonStyle(WhiteButtonStyle(height: 40.0))

                    Button("로그인"){
                        authViewModel.signIn(email: emailText, password: passwordText)
                        dismiss()
                    }
                    .buttonStyle(WhiteButtonStyle(height: 40.0))
                        .foregroundStyle(emailText.isEmpty || passwordText.isEmpty ? .gray : .accentColor)
                        .disabled(emailText.isEmpty || passwordText.isEmpty ? true : false)
                }
                .padding(.top)
                
                Text("다른 방법으로 로그인")
                    .padding()
                
                Button(action: {
                    authViewModelGoogle.signIn(email: nil, password: nil)
                    dismiss()
                }) {
                    Image("SignInWithGoogle")
                        .resizable()
                        .frame(width: 335, height: 50)
                }
                .padding(.bottom, 10)
                SpaceBox()
            }
            .padding(.horizontal, 30)
            .fullScreenCover(isPresented: $isSignUpScreen, content: {
                SignUpView()
            })
        }
    }
}

#Preview {
    RLoginView(isPresentedLogin: .constant(true))
}
