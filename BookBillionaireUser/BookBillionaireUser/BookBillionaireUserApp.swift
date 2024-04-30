//
//  BookBillionaireUserApp.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct BookBillionaireUserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel: AuthViewModel = AuthViewModel.shared
    @StateObject private var authViewModelGoogle: AuthViewModelGoogle = AuthViewModelGoogle()
    @StateObject private var bookService: BookService = BookService()
    @StateObject private var userService: UserService = UserService()
    @StateObject private var rentalService: RentalService = RentalService()
    @StateObject private var htmlLoadService: HtmlLoadServicee = HtmlLoadServicee()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(authViewModelGoogle)
                .environmentObject(bookService)
                .environmentObject(userService)
                .environmentObject(rentalService)
                .environmentObject(htmlLoadService)
                .task {
                    await bookService.loadBooks()
                    await userService.loadUsers()
                    await rentalService.loadRentals()
                    await htmlLoadService.fetchAllDocs()
                }
        }
    }
}
