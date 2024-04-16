//
//  SignUpView.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 3/25/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var passwordConfirmText: String = ""
    @State private var isShowingProgressView = false
    @State private var isShowingAlert: Bool = false
    @State private var isPasswordCountError: Bool = false
    @State private var isPasswordUnCorrectError: Bool = false
    @State private var isEmailError: Bool = false
    @State private var nicknameErrorText: String = ""
    @State private var nicknameErrorTextColor: Color = .clear
    @State private var emailErrorText: String = ""
    @State private var emailErrorText2: String = ""
    @State private var emailErrorText2Color: Color = .clear
    @State private var isSecure: Bool = true
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                Text("회원가입")
                VStack(alignment: .leading) {
                    Text("닉네임")
                        .foregroundStyle(.primary)
                    ZStack(alignment: .trailing) {
                        TextField("닉네임을 입력해주세요", text: $nameText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                        Button(action: {
                            if !nameText.isEmpty {
                                if containsSpecialCharacters(nameText) {
                                    nicknameErrorTextColor = .red
                                    nicknameErrorText = "띄어쓰기 및 특수문자 입력이 제한됩니다."
                                } else {
                                    authViewModel.checkNicknameDuplication(nameText) { isUnique in
                                        if !isUnique {
                                            print("닉네임이 중복됩니다.")
                                            nicknameErrorTextColor = .red
                                            nicknameErrorText = "닉네임이 중복됩니다. 다른 닉네임을 사용해주세요."
                                        } else {
                                            print("닉네임이 중복되지 않습니다.")
                                            nicknameErrorTextColor = .blue
                                            nicknameErrorText = "사용 가능한 닉네임 입니다."
                                        }
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        })
                        .padding(.trailing, 15)
                    }
                    Text(nicknameErrorText)
                        .foregroundColor(nicknameErrorTextColor)
                        .padding(.leading, 10)
                    Text("이메일")
                        .foregroundStyle(.primary)
                    ZStack(alignment: .trailing) {
                        TextField("이메일을 입력해주세요", text: $emailText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.none)
                            .autocapitalization(.none)
                            .onChange(of: emailText, perform: { newValue in
                                isEmailError = !isValidEmail(newValue)
                                emailErrorText = "올바른 이메일 형식이 아닙니다."
                                emailErrorText2 = ""
                            })
                        Button(action: {
                            if !isValidEmail(emailText) {
                                emailErrorText = "올바른 이메일 형식이 아닙니다."
                                emailErrorText2 = ""
                            } else {
                                if !emailText.isEmpty {
                                    authViewModel.checkEmailDuplication(emailText) { isUnique in
                                        if !isUnique {
                                            print("이메일이 중복됩니다.")
                                            emailErrorText2Color = .red
                                            emailErrorText2 = "이메일이 중복됩니다. 다른 이메일을 사용해주세요."
                                        } else {
                                            print("이메일이 중복되지 않습니다.")
                                            emailErrorText2Color = .blue
                                            emailErrorText2 = "사용 가능한 이메일 입니다."
                                        }
                                        emailErrorText = ""
                                    }
                                }
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        })
                        .padding(.trailing, 15)
                    }
                    ZStack {
                        Text(emailErrorText)
                            .foregroundColor(isEmailError ? .red : .clear)
                            .padding(.leading, 10)
                        Text(emailErrorText2)
                            .foregroundColor(emailErrorText2Color)
                            .padding(.leading, 10)
                    }
                    Text("비밀번호")
                        .foregroundStyle(.primary)
                        ZStack(alignment: .trailing) {
                            if isSecure {
                                SecureField("비밀번호", text: $passwordText)
                                    .padding()
                                    .background(.thinMaterial)
                                    .cornerRadius(10)
                            } else {
                                TextField("비밀번호", text: $passwordText)
                                    .padding()
                                    .background(.thinMaterial)
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.none)
                                    .autocapitalization(.none)
                            }
                            Button {
                                isSecure.toggle()
                            } label: {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.primary)
                            }
                            .padding(.trailing, 10)
                        }
                        Text("비밀번호는 6자리 이상 입력해주세요.")
                            .foregroundColor(isPasswordCountError ? .red : .clear)
                            .padding(.leading, 10)
                        Text("비밀번호 확인")
                            .foregroundStyle(.primary)
                        ZStack(alignment: .trailing) {
                            if isSecure {
                                SecureField("비밀번호를 다시 입력해주세요", text: $passwordConfirmText)
                                    .padding()
                                    .background(.thinMaterial)
                                    .border(.red, width: passwordConfirmText != passwordText ? 1 : 0)
                                    .cornerRadius(10)
                            } else {
                                TextField("비밀번호를 다시 입력해주세요", text: $passwordConfirmText)
                                    .padding()
                                    .background(.thinMaterial)
                                    .border(.red, width: passwordConfirmText != passwordText ? 1 : 0)
                                    .cornerRadius(10)
                                    .textInputAutocapitalization(.none)
                                    .autocapitalization(.none)
                            }
                            Button {
                                isSecure.toggle()
                            } label: {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.primary)
                            }
                            .padding(.trailing, 10)
                        }
                        Text("비밀번호가 서로 다릅니다.")
                            .foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                            .padding(.leading, 10)
                    }
                    
                    Button {
                        isShowingProgressView = true
                        
                        if containsSpecialCharacters(nameText) {
                            nicknameErrorTextColor = .red
                            nicknameErrorText = "띄어쓰기 및 특수문자 입력이 제한됩니다."
                            isShowingProgressView = false
                        }
                        
                        if passwordText.count < 6 {
                            isPasswordCountError = true
                            isShowingProgressView = false
                        }
                        if passwordConfirmText != passwordText {
                            isPasswordUnCorrectError = true
                            isShowingProgressView = false
                        }
                        if !isValidEmail(emailText) {
                            isEmailError = true
                            emailErrorText = "올바른 이메일 형식이 아닙니다."
                            isShowingProgressView = false
                        }
                        if passwordText.count >= 6 && passwordConfirmText == passwordText && isValidEmail(emailText) {
                            authViewModel.signUp(email: emailText, userName: nameText, password: passwordText)
                            isShowingAlert = true
                            isShowingProgressView = false
                        }
                    } label: {
                        Text("회원 가입")
                            .frame(width: 100, height: 50)
                            .background(!checkSignUpCondition() ? .gray : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .alert("회원가입", isPresented: $isShowingAlert) {
                                Button {
                                    dismiss()
                                } label: {
                                    Text("OK")
                                }
                            } message: {
                                Text("회원가입이 완료되었습니다.")
                            }
                    }
                    .disabled(!checkSignUpCondition())
                    
                    if isShowingProgressView {
                        ProgressView()
                    }
                }
                .padding()
                .padding(.bottom, 15)
            }
        }
    private func checkSignUpCondition () -> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || passwordConfirmText.isEmpty {
            return false
        }
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    private func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9_가-힣]", options: [])
        return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) != nil
    }
}

#Preview { SignUpView() }
