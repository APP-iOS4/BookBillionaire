//
//  AuthenticationViewModel.swift
//  temp30_table
//
//  Created by Seungjae Yu on 4/8/24.
//  https://elisha0103.tistory.com/9

import Firebase
import GoogleSignIn

class AuthViewModelGoogle: ObservableObject, AuthViewModelProtocol {
    
    @Published var state: AuthState = .loggedOut
    let signInMethod: SignInMethod = .google

    var authViewModel: AuthViewModel // Assuming AuthViewModel is a regular class

    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    // google 로그인 절차
    func signIn(email: String?, password: String?) {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // 3
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            // 4
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 5
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[unowned self] result, error in
                guard let result = result else { return }
                authenticateUser(for: result.user, with: error)
            }
        }
    }
    
    // firebase 로그인 절차
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // 2
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        // 3
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .loggedIn
                self.authViewModel.state = .loggedIn
                print("사용자 이메일: \(String(describing: result?.user.email))")
                print("사용자 이름: \(String(describing: result?.user.displayName))") //nil 리턴
            }
        }
    }
    
    func readUserData(uid: String) {
    
    }
    
    
    // 로그아웃 절차
    func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()
        
        do {
            // 2
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
