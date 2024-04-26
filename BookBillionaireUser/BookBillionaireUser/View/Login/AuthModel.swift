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
    case apple
}

protocol AuthViewModelProtocol {
    var signInMethod: SignInMethod { get }
    
    func signIn(email: String?, password: String?)
    
}
