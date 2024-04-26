//
//  SignUpView.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 3/25/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var nameText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var passwordConfirmText = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var nicknameValidated = false
    @State private var emailValidated = false
    @State private var disableControlls: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                Text("회원가입")
                SignUpDetailView(nameText: $nameText, emailText: $emailText, passwordText: $passwordText, passwordConfirmText: $passwordConfirmText, nicknameValidated: $nicknameValidated, emailValidated: $emailValidated, disableControlls: $disableControlls)
                Text(!isFormValid ? "모든 필드를 기입하시고 '중복체크'를 해주세요!" : "회원가입 버튼을 눌러 주세요!")
                Button("회원 가입") {
                    performSignUp()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(!isFormValid)
            }
            .padding()
            .padding(.bottom, 15)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("회원가입"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
    
    private func performSignUp() {
        guard !nameText.isEmpty, !emailText.isEmpty, passwordText.count >= 6, passwordText == passwordConfirmText, isValidEmail(emailText) else {
            alertMessage = "모든 필드를 올바르게 입력해주세요."
            showAlert = true
            return
        }

        // 닉네임과 이메일의 중복 검사 로직 (AuthViewModel 사용)
        authViewModel.checkNicknameDuplication(nameText) { isUniqueNickname in
            if !isUniqueNickname {
                print("닉네임이 중복됩니다. 다른 닉네임을 사용해주세요.")
            } else {
                authViewModel.checkEmailDuplication(emailText) { isUniqueEmail in
                    if !isUniqueEmail {
                        print("이메일이 중복됩니다. 다른 이메일을 사용해주세요.")
                    } else {
                        // 모든 조건이 충족되면 실제 회원 가입 진행
                        disableControlls = true
                        authViewModel.signUp(email: emailText, userName: nameText, password: passwordText) { success in
                            alertMessage = success ? "회원가입이 성공적으로 완료되었습니다." : "회원가입에 실패했습니다. 입력 정보를 확인하거나 나중에 다시 시도해주세요."
                            showAlert = true
                            dismiss()
                        }
                    }
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    private var isFormValid: Bool {
        !nameText.isEmpty &&
        !emailText.isEmpty &&
        passwordText.count >= 6 &&
        passwordText == passwordConfirmText &&
        isValidEmail(emailText) &&
        nicknameValidated &&
        emailValidated
    }
}

#Preview { SignUpView() }
