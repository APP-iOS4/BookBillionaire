//
//  ContentView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookService: BookService
    @State private var selectedTab: Tab = .home
    
    enum Tab: String {
        case home = "홈"
        case library = "내 서재"
        case chat = "메세지"
        case profile = "마이프로필"
        
        var symbolImage: String {
            switch self {
            case .home:
                return "house"
            case .library:
                return "books.vertical"
            case .chat:
                return "message"
            case .profile:
                return "person.crop.circle.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tag(Tab.home)
            .tabItem {
                Label(Tab.home.rawValue, systemImage: Tab.home.symbolImage)
            }
            
            NavigationStack {
                LibraryView()
            }
            .tag(Tab.library)
            .tabItem {
                Label(Tab.library.rawValue, systemImage: Tab.library.symbolImage)
            }
            
            NavigationStack {
                ChatListView()
            }
            .tag(Tab.chat)
            .tabItem {
                Label(Tab.chat.rawValue, systemImage: Tab.chat.symbolImage)
            }
            
            NavigationStack {
                ProfileView()
            }
            .tag(Tab.profile)
            .tabItem {
                Label(Tab.profile.rawValue, systemImage: Tab.profile.symbolImage)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BookService())
        .environmentObject(UserService())
        .environmentObject(AuthViewModel())
}


