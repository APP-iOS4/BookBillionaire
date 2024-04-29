//
//  UserSearchView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/26/24.
//

import SwiftUI
import BookBillionaireCore

struct UserSearchBar: View {
    @State var isSearching = false
    @State var searchText: String = ""
    @EnvironmentObject var userService: UserService
    @Binding var result: [User]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                TextField("  유저 아이디를 입력해주세요", text: $searchText)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                        // 텍스트 삭제 버튼
                        HStack {
                            Spacer()
                          if searchText !=  ""{
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .padding(.trailing, 5)
                    }
                    .onChange(of: searchText) { _ in
                        isSearching = false
                    }
                
                Button {
                    result = userService.loadUserByID(searchText)
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("책 검색하기")
    }
}

#Preview {
    UserSearchBar(result: .constant([]))
}
