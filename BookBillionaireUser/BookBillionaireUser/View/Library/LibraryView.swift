//
//  LibraryView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedIndex: Int = 0
    @State private var isShowing: Bool = false
    
    var body: some View {
        switch authViewModel.state {
        case .loggedIn:
            VStack {
                Section(header: CategoryView(selectedIndex: $selectedIndex)) {
                    if selectedIndex == 0 {
                        MyBookListView()
                    } else {
                        RentalBookListView()
                    }
                    Spacer()
                }
            }
            .toolbarBackground(.background, for: .navigationBar)
            .navigationTitle("내 서재")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        NavigationLink {
                            APISearchView(isShowing: $isShowing)
                        } label: {
                            Label("검색으로 등록하기", systemImage: "magnifyingglass")
                        }
                        
                        NavigationLink {
                            BookCreateView()
                        } label: {
                            Label("입력으로 등록하기", systemImage: "square.and.pencil")
                        }
                    } label: {
                        if selectedIndex == 0 {
                            Label("plus", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        case .loggedOut:
            UnlogginedView()
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
            .environmentObject(AuthViewModel())
    }
}
