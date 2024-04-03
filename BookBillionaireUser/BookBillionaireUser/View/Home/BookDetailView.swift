//
//  BookDetailView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct BookDetailView: View {
    var book: Book
    var user: User
    
    var body: some View {
      
            ScrollView{
                ZStack{
                    AsyncImage(url: URL(string: "https://picsum.photos/id/237/200/300")){ image in
                        image.resizable(resizingMode: .stretch)
                            .ignoresSafeArea()
                            .blur(radius: 8.0,opaque: true)
                    } placeholder: {
                        Rectangle().background(.black)
                    }
                    .background(Color.gray)
                    VStack{
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 25.0, topTrailing: 25.0))
                            .frame(height: 100)
                            .foregroundStyle(Color.white)
                            .padding(.top, 200)
                    }
                        AsyncImage(url: URL(string: "https://picsum.photos/id/237/200/300")){ image in
                            image.resizable()
                                .ignoresSafeArea()
                                .frame(width: 200)
                        } placeholder: {
                            ProgressView()
                        }
                        .position(x:200,y:250)
                }
                VStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 100)
                        .foregroundStyle(.clear)
                    HStack{
                        Text(book.title)
                            .font(.title)
                            .bold()
                        Button {
                            
                        } label: {
                            
                        }
                    }
                    HStack{
                        Button("메세지 보내기"){
                            
                        }

                        Spacer()
                        
                        Button("대여 신청"){
                            
                        }
                      
                    }
                    .padding(.top, -20)
                    HStack {
                        Spacer()
                        Text("책 소유자 : ")
                        Text(user.name)
                        Image(user.image ?? "")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    Section{
                        Text("작품소개")
                            .font(.subheadline)
                            .bold()
                        Text(book.contents)
                            .font(.system(size: 13))
                    }
                    HStack{
                        if book.authors.isEmpty {
                            Text("저자를 찾을 수 없어요.")
                        }else {
                            ForEach(book.authors, id: \.self) {author in
                                Text(author)
                            }
                        }
                        Divider()
                        ForEach(book.translators ?? [""], id: \.self) { translator in Text("번역:\(translator)")
                        }
                        Spacer()
                        Text(book.bookCategory?.rawValue ?? "")
                    }
                    .font(.caption)
                    
                    Divider()
                        .padding(.vertical)
                    Text("📖 읽고싶은 책인데 대여중이라면?")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    VStack{
                        HStack{
                            Image(user.image ?? "")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            Text(user.name).font(.headline)
                            Spacer()
                            Button {
                                
                            } label: {
                                
                            }
                        }
                        HStack{
                            Image(user.image ?? "")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            Text(user.name).font(.headline)
                            Spacer()
                            Button {
                                
                            } label: {
                                
                            }
                        }
                        HStack{
                            Image(user.image ?? "")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            Text(user.name).font(.headline)
                            Spacer()
                            Button {
                                
                            } label: {
                                
                            }
                        }
                        HStack{
                            Image(user.image ?? "")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            Text(user.name).font(.headline)
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("")
                            }
                        }
                    }
                    .padding()
                    Section{
                        
                    }
                    Rectangle()
                        .frame(height: 80)
                        .foregroundStyle(.clear)
                }
                .padding(.horizontal)
                
            }
            
            .ignoresSafeArea()
        }
        
    }



#Preview {
        BookDetailView(book: Book.sample, user: User.sample)
}
