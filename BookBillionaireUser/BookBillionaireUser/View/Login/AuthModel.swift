//
//  AuthModel.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 4/9/24.
//

import Foundation

enum AuthState {
    case loggedIn
    case loggedOut
}

enum SignInMethod {
    case email
    case google
}

protocol AuthViewModelProtocol {
    var state: AuthState { get set }
    var signInMethod: SignInMethod { get }
    
    func signIn(email: String?, password: String?)
    func readUserData(uid: String)
}
