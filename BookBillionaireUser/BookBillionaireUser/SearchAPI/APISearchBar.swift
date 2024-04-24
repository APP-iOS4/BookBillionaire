//
//  SearchBarAPI.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/25/24.
//

import SwiftUI

struct APISearchBar: View {
    @Binding var searchBook: String?
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("검색어 입력", text: $searchBook.orEmpty)
                .keyboardType(.webSearch)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit(onSearch)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
            
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
    }
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        get { self ?? "" }
        set { self = newValue }
    }
}

