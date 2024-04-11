//
//  RentalBookListView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalBookListView: View {
    let bookService: BookService = BookService.shared
    @State var myBooks: [Book] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("빌린도서 목록")
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            // 빌린도서 목록 미구현으로 보유도서 목록으로 더미데이터 사용
            if myBooks.isEmpty {
                VStack(spacing: 10) {
                    Spacer()
                    Circle()
                        .stroke(lineWidth: 3)
                        .overlay {
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(20)
                        }
                        .frame(width: 70, height: 70)
                    
                    Text("대여중인 도서가 없습니다.")
                    Text("대여가 완료되면 여기에 표시됩니다.")
                    Spacer()
                }
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(myBooks, id: \.self) { book in
                            
                        }
                    }
                    .padding()
                    SpaceBox()
                }
            }
        }
//        .onAppear{
//            loadMybook()
//        }
    }
    
    private func loadMybook() {
        Task {
            myBooks = await bookService.loadBookByID("Eyhr4YQGsATlRDUcc9rYl9PZYk52")
        }
    }
}

#Preview {
    NavigationStack {
        RentalBookListView()
    }
}
