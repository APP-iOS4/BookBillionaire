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
    @State private var isShowingInput: Bool = false
    @State private var isShowingSearch: Bool = false
    
    var body: some View {
        switch authViewModel.state {
        case .loggedIn:
            VStack {
                // 카테고리 선택
                Section(header: CategoryView(selectedIndex: $selectedIndex)) {
                    if selectedIndex == 0 {
                        MyBookListView()
                    } else {
                        RentalBookListView()
                    }
                    Spacer()
                }
            }
            .navigationTitle("내 서재")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // 메뉴 버튼
                    Menu {
                        Button {
                            isShowingSearch.toggle()
                        } label: {
                            Label("검색으로 등록하기", systemImage: "magnifyingglass")
                        }
                        
                        Button {
                            isShowingInput.toggle()
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
                    
                }
            }
            .fullScreenCover(isPresented: $isShowingSearch) {
                    APISearchView(isShowing: $isShowingSearch)
                        .toolbar(.hidden, for: .tabBar)
            }
            .fullScreenCover(isPresented: $isShowingInput) {
                NavigationStack {
                    BookCreateView(viewType: .input, isShowing: $isShowingInput)
                }
            }
        case .loggedOut:
            UnlogginedView()
                .padding()
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
            .environmentObject(AuthViewModel())
            .environmentObject(BookService())
            .environmentObject(UserService())
    }
}
