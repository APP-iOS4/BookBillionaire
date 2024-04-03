//
//  MyBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct MyBookListView: View {
    var body: some View {
        VStack {
            HStack {
                Text("보유도서 목록")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.medium)
                Spacer()
            }
            LazyVStack(alignment: .leading, spacing: 10) {
                // bookStore 미구현, 추후 변경
                ForEach(0..<3, id: \.self) { book in
                    // ListRowView 미구현, 추후 변경
                    NavigationLink(value: book) {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 100, height: 120)
                                .background(Color.gray)
                            VStack(alignment: .leading) {
                                Text("책 이름")
                                Text("작가 이름")
                                Spacer()
                            }
                        }
                    }
                }
                .foregroundStyle(Color.black)
            }
        }
        // DetailView 미구현, 추후 변경
        .navigationDestination(for: Int.self) { value in
            Text("안녕 DetailView")
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        MyBookListView()
    }
}
