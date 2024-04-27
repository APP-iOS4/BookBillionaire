//  SignUpDetailView.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 4/22/24.
//

import SwiftUI

struct SignUpDetailView: View {
    @Binding var nameText: String
    @Binding var emailText: String
    @Binding var passwordText: String
    @Binding var passwordConfirmText: String
    @Binding var nicknameValidated: Bool
    @Binding var emailValidated: Bool
    @Binding var disableControlls: Bool
    
    @State private var isShowingAlert: Bool = false
    @State private var isPasswordCountError: Bool = false
    @State private var isPasswordUnCorrectError: Bool = false
    @State private var isEmailError: Bool = false
    @State private var nicknameErrorText: String = ""
    @State private var nicknameErrorTextColor: Color = .clear
    @State private var emailErrorText: String = ""
    @State private var emailErrorText2: String = ""
    @State private var emailErrorText2Color: Color = .clear
//    @State private var validationNickname: Bool = false
//    @State private var validationEmail: Bool = false
    @State private var isSecure: Bool = true
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    let signUpView = SignUpView()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .foregroundStyle(.primary)
            ZStack(alignment: .trailing) {
                TextField("닉네임을 입력해주세요", text: $nameText)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                    .disabled(disableControlls)
                Button(action: {
                    if !nameText.isEmpty {
                        if containsSpecialCharacters(nameText) {
                            nicknameErrorTextColor = .red
                            nicknameErrorText = "띄어쓰기 및 특수문자 입력이 제한됩니다."
                            nicknameValidated = false
                        } else {
                            authViewModel.checkNicknameDuplication(nameText) { isUnique in
                                if !isUnique {
                                    print("닉네임이 중복됩니다.")
                                    nicknameErrorTextColor = .red
                                    nicknameErrorText = "닉네임이 중복됩니다. 다른 닉네임을 사용해주세요."
                                    nicknameValidated = false
                                } else {
                                    print("닉네임이 중복되지 않습니다.")
                                    nicknameErrorTextColor = .blue
                                    nicknameErrorText = "사용 가능한 닉네임 입니다."
                                    nicknameValidated = true
                                }
                            }
                        }
                    }
                }, label: {
                    Text("중복체크")
                        .foregroundColor(.primary)
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
                        isEmailError = !signUpView.isValidEmail(newValue)
                        emailErrorText = "올바른 이메일 형식이 아닙니다."
                        emailErrorText2 = ""
                        emailValidated = false
                    })
                    .disabled(disableControlls)
                Button(action: {
                    if !signUpView.isValidEmail(emailText) {
                        emailErrorText = "올바른 이메일 형식이 아닙니다."
                        emailErrorText2 = ""
                        emailValidated = false
                    } else {
                        if !emailText.isEmpty {
                            authViewModel.checkEmailDuplication(emailText) { isUnique in
                                if !isUnique {
                                    print("이메일이 중복됩니다.")
                                    emailErrorText2Color = .red
                                    emailErrorText2 = "이메일이 중복됩니다. 다른 이메일을 사용해주세요."
                                    emailValidated = false
                                } else {
                                    print("이메일이 중복되지 않습니다.")
                                    emailErrorText2Color = .blue
                                    emailErrorText2 = "사용 가능한 이메일 입니다."
                                    emailValidated = true
                                }
                                emailErrorText = ""
                            }
                        }
                    }
                }, label: {
                    Text("중복체크")
                        .foregroundColor(.primary)
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
                        .disabled(disableControlls)
                } else {
                    TextField("비밀번호", text: $passwordText)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                        .disabled(disableControlls)
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
//                        .border(.red, width: passwordConfirmText != passwordText ? 3 : 0)
                        .cornerRadius(10)
                        .disabled(disableControlls)
                } else {
                    TextField("비밀번호를 다시 입력해주세요", text: $passwordConfirmText)
                        .padding()
                        .background(.thinMaterial)
//                        .border(.red, width: passwordConfirmText != passwordText ? 3 : 0)
                        .cornerRadius(10)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                        .disabled(disableControlls)
                }
                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 10)
                .disabled(disableControlls)
            }
            Text("비밀번호가 서로 다릅니다.")
                .foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                .padding(.leading, 10)
        }
    }
    
    private func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9_가-힣]", options: [])
        return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) != nil
    }
}

//#Preview {
//    SignUpDetailView()
//}
