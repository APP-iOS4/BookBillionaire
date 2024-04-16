//
//  ContentView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookService: BookService
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tag(0)
            .tabItem {
                Label("홈", systemImage: "house")
            }
            
            NavigationStack {
                LibraryView()
            }
            .tag(1)
            .tabItem {
                Label("내 서재", systemImage: "books.vertical")
            }
            
            NavigationStack {
                ChatListView()
            }
            .tag(2)
            .tabItem {
                Label("메세지", systemImage: "message")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tag(3)
            .tabItem {
                Label("마이프로필", systemImage: "person.crop.circle.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
