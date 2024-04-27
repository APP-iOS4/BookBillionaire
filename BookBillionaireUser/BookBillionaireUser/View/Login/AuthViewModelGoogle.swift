//
//  AuthenticationViewModel.swift
//  temp30_table
//
//  Created by Seungjae Yu on 4/8/24.
//  https://elisha0103.tistory.com/9
import Firebase
import GoogleSignIn

class AuthViewModelGoogle: ObservableObject, AuthViewModelProtocol {
    let signInMethod: SignInMethod = .google
    
    // google 로그인 절차
    func signIn(email: String?, password: String?) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[unowned self] result, error in
                guard let result = result else { return }
                authenticateUser(for: result.user, with: error)
            }
        }
    }
    
    // firebase 로그인 절차
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { [self] (result, error) in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
            } else {
                print("Successfully signed in with Google")
                AuthViewModel.shared.state = .loggedIn

                print("사용자 이메일: \(String(describing: result?.user.email))")
                print("사용자 이름: \(String(describing: result?.user.displayName))")
                
                if let isNewUser = result?.additionalUserInfo?.isNewUser, isNewUser {
                    signUp(user: result?.user)
                }
            }
        }
    }
    
    // firebase 회원가입
    private func signUp(user: User?) {
        // Perform sign-up process here
        // You can implement your sign-up logic in this function
        if let user = user {
            // Firestore에 사용자 정보 및 생성일자 저장
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "emailEqualtoAuth": user.email ?? "",
                "nickname": user.displayName ?? "",
                "createdAt": Timestamp(date: Date()), // 현재 시간을 Timestamp로 변환하여 저장
                "id": user.uid,
                "introduction": "",
                "profileImage": "profile/defaultUser.jpeg"
            ]
            db.collection("User").document(user.uid).setData(userData) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    return
                }
                print("사용자 데이터가 성공적으로 저장되었습니다.")
                
                // 사용자 데이터를 다시 읽어와서 출력
                AuthViewModel.shared.readUserData(uid: user.uid)
            }
        }
    }
}
