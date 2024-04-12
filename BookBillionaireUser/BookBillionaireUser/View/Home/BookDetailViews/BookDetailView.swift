//
//  BookDetailView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailView: View {
    let book: Book
    let user: User
    
    var body: some View {
        ScrollView{
            BookDetailImageView(book: book)
            HStack {
                // 설정 버튼
                Menu {
                    Button {
                        
                    } label: {
                        Label("게시물 보관하기", systemImage: "square.and.arrow.down")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("게시물 공유하기", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("신고하기", systemImage: "exclamationmark.triangle")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundStyle(.accent)
                }
            }
            .offset(x: 170, y: -90)

            // 정보란
            VStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 100)
                        .foregroundStyle(.clear)
                    Spacer()
                
                HStack{
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    StatusButton(status: book.rentalState)
                }
         
                HStack{
                    Button {
                        
                    } label: {
                        Text("메세지 보내기")
                    }
                    .buttonStyle(WhiteButtonStyle(height: 40.0, font: .headline))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("대여 신청")
                    }
                    .buttonStyle(AccentButtonStyle(height: 40.0, font: .headline))
                }

                HStack {
                    Spacer()
                    Text("책 소유자 : ")
                    Text(user.nickName)
                    Image(user.image ?? "default")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                Section{
                    Text("작품소개")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(book.contents)
                        .font(.system(size: 13))
                }
                
                HStack{
                    if book.authors.isEmpty {
                        Text("저자를 찾을 수 없어요.")
                    } else {
                        ForEach(book.authors, id: \.self) { author in
                            Text(author)
                        }
                    }
                    Divider()
                    ForEach(book.translators ?? ["번역자"], id: \.self) { translator in Text("번역:\(translator)")
                    }
                    Spacer()
                    Text(book.bookCategory?.rawValue ?? "카테고리")
                }
                .font(.caption)
                
                Divider()
                    .padding(.vertical)
                
                // 책 목록
                Text("📖 읽고싶은 책인데 대여중이라면?")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                VStack{
                    BookDetailUserListView(book: book, user: user)
                    BookDetailUserListView(book: book, user: user)
                    BookDetailUserListView(book: book, user: user)
                    BookDetailUserListView(book: book, user: user)
                }
            }
            .padding(.horizontal)
            .navigationTitle(book.title)
        }
        .ignoresSafeArea()
        SpaceBox()
    }
    
}

#Preview {
    BookDetailView(book: Book(owenerID: "", title: "책이름", contents: "줄거리", authors: ["작가"], rentalState: RentalStateType(rawValue: "") ?? .rentalAvailable), user: User(id: "책유저", nickName: "닉네임", address: "주소"))
}
