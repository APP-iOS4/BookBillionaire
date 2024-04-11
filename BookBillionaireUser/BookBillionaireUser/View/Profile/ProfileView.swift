//
//  ProfileView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggedIn: Bool = false
    @State private var userEmail: String? // New state variable to hold user's email
    @State private var userUID: String? // New state variable to hold user's UID
    
    
    var body: some View {
        VStack {
            if authViewModel.state == .loggedOut {
                UnlogginedView()
            } else {
                
            }
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
