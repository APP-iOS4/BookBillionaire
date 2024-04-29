//
//  ProfileViewModel.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/28/24.
//

import Foundation
import FirebaseAuth
import BookBillionaireCore

class ProfileViewModel: ObservableObject {
    @Published var user = User()
    @Published var favoriteBooksCount: Int = 0
    @Published var myBooksCount: Int = 0
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String?
    @Published var userUID: String?
    @Published var shouldLogout: Bool = false
    
    let userService: UserService
    let bookService: BookService
    let authViewModel: AuthViewModel
    
    init(userService: UserService, bookService: BookService, authViewModel: AuthViewModel) {
        self.userService = userService
        self.bookService = bookService
        self.authViewModel = authViewModel
    }
    
    func loadMyProfile() {
        Task {
            if let currentUser = AuthViewModel.shared.currentUser {
                user = userService.loadUserByID(currentUser.uid)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            userEmail = nil
            userUID = nil
        } catch {
            print("Error occurred during logout:", error.localizedDescription)
        }
    }
    
    func loadFavoriteBooksCount(userID: String) {
        Task {
            favoriteBooksCount = await userService.getFavoriteBooksCount(userID: userID)
        }
    }
    
    func loadMyBooksCount(userID: String) {
        Task {
            myBooksCount = await userService.getMyBookCount(userID: userID)
        }
    }
}

