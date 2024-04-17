//
//  SearchBarAPI.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/25/24.
//

import SwiftUI

struct APISearchBar: View {
    @Binding var searchBook: String
    var onSearch: () -> Void
    
    var body: some View {
        VStack{
            HStack {
                TextField("검색어 입력", text: $searchBook)
                    .keyboardType(.webSearch)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("AccentColor"),lineWidth: 1)
                    }
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding()
        }
    }
}

