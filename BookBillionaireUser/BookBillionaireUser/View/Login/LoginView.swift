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
            ZStack {
                Color.accentColor1
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo")
                        .frame(width: 200, height: 200)
                        .padding(.top, 50)
                    ZStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(10)
                            .frame(width: 335, height: 250)
                        VStack(spacing: 20) {
                            TextField("email", text: $emailText)
                                .padding()
                                .padding(.horizontal, 20)
                                .cornerRadius(10)
                                .background(.thinMaterial)
                                .foregroundColor(Color(hex: 0x014073))
                                .textInputAutocapitalization(.never)
                                .autocapitalization(.none)
                            SecureField("Password", text: $passwordText)
                                .padding()
                                .padding(.horizontal, 20)
                                .cornerRadius(10)
                                .background(.thinMaterial)
                                .foregroundColor(Color(hex: 0x014073))
                            
                            HStack(spacing: 10) {
                                Spacer()
                                NavigationLink {
                                    SignUpView()
                                } label: {
                                    HStack {
                                        Text("회원가입")
                                            .foregroundColor(Color(hex: 0x014073))
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
                                            .foregroundColor(Color(hex: 0x014073))
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
                    }
                    .padding(.horizontal, 50)
                    Text("Or")
                        .foregroundColor(.white)
                        .padding()
                    Image("SignInWithGoogle")
                    Image("SignInWithGoogle")
                    Spacer()
                }
            }
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex) & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

#Preview {
    LoginView()
}

