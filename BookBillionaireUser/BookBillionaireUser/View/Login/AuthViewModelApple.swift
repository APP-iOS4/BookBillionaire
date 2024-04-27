//
//  AuthViewModelApple.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 4/26/24.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseAuth

struct AppleSigninButton: View {
    
    let signInMethod: SignInMethod = .apple
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Apple Login Successful")
                    if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                        // Extract the identity token and authorization code
                        guard let identityTokenData = appleIDCredential.identityToken,
                              let authorizationCodeData = appleIDCredential.authorizationCode,
                              let identityToken = String(data: identityTokenData, encoding: .utf8),
                              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
                                  print("Error: Unable to extract tokens")
                                  return
                        }
                        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                  idToken: identityToken,
                                                                  rawNonce: nil, // Optional: implement nonce handling if you are following best security practices
                                                                  accessToken: authorizationCode)

                        // Authenticate with Firebase
                        authenticateWithFirebase(credential: credential)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        )
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
        .cornerRadius(5)
    }
    
    private func authenticateWithFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("Error signing in with Apple: \(error.localizedDescription)")
            } else {
                print("Successfully signed in with Apple")
                AuthViewModel.shared.state = .loggedIn
                if let user = result?.user {
                    print("사용자 이메일: \(String(describing: user.email))")
                    print("사용자 이름: \(String(describing: user.displayName))")
                    if let isNewUser = result?.additionalUserInfo?.isNewUser, isNewUser {
                        signUp(user: user)
                    }
                }
            }
        }
    }
    
    // The signUp function is similar to the one in your Google authentication example
    private func signUp(user: User) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "emailEqualtoAuth": user.email ?? "",
            "nickname": user.displayName ?? "",
            "createdAt": Timestamp(date: Date()),
            "id": user.uid,
            "introduction": "",
            "profileImage": "person.crop.circle"
        ]
        db.collection("User").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("사용자 데이터가 성공적으로 저장되었습니다.")
            }
        }
    }
}
//#Preview {
//    AuthViewModelApple()
//}
