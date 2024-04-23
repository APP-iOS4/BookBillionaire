//
//  BookBillionaireAdminApp.swift
//  BookBillionaireAdmin
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct BookBillionaireUserApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var userService: UserService = UserService()
    @StateObject var bookService: BookService = BookService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
                .environmentObject(bookService)

        }
    }
}
