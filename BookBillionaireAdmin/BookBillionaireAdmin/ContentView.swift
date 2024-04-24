//
//  ContentView.swift
//  BookBillionaireAdmin
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTabIndex: Int = 0
    @State var navigationSplitViewVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $navigationSplitViewVisibility) {
            SideBarView()
        } detail: {
            Image("logoShortCut")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
            Text("Select a board")
                .font(.title)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserService())
        .environmentObject(BookService())
}
