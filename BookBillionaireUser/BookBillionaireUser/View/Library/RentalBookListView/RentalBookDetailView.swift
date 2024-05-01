//
//  RentalBookDetailView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/25/24.
//

import SwiftUI
import BookBillionaireCore
import FirebaseStorage

struct RentalBookDetailView: View {
    var book: Book
    var rental: Rental
    var user: User
    let imageChache = ImageCache.shared
    @State private var bookImageUrl: URL?
    @State private var userImageUrl: URL?
    @State private var loadedImage: UIImage?
    @State private var isShowingReturnSheet: Bool = false
    @State private var isShowingExtensionSheet: Bool = false
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                if let url = bookImageUrl, !url.absoluteString.isEmpty {
                    Image(uiImage: loadedImage ?? UIImage(named: "default")!)
                        .resizable()
                        .frame(width: 200, height: 300)
                        .onAppear {
                            ImageCache.shared.getImage(for: url) { image in
                                loadedImage = image
                            }
                        }
                } else {
                    Image("default")
                        .resizable()
                        .frame(width: 200, height: 300)
                }
                    
                HStack {
                    Button("대여 연장") {
                        isShowingExtensionSheet.toggle()
                    }
                    .buttonStyle(WhiteButtonStyle(height: 45))
                    
                    Button("대여 반납") {
                        isShowingReturnSheet.toggle()
                    }
                    .buttonStyle(AccentButtonStyle(height: 45))
                }
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            if let url = userImageUrl {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    Image("defaultUser1")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                }
                            } else {
                                Image("defaultUser1")
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 30, height: 30)
                            }
                            VStack(alignment: .leading) {
                                Text(user.nickName)
                                    .font(.body)
                                Text(user.address)
                                    .font(.caption)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("대여 기간: \(dateFormatter.string(from: rental.rentalStartDay)) ~ \(dateFormatter.string(from: rental.rentalEndDay))")
                            }
                            .font(.caption)
                            .foregroundStyle(.gray)
                        }
                    }
                    .font(.headline)
                    Spacer()
                }
                .padding(.vertical, 10)
                Divider()
                VStack(alignment: .leading) {
                    Text("기본 정보")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("책 소개")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 3)
                    Text(book.contents)
                        .lineSpacing(5)
                        .font(.subheadline)
                    Divider()
                        .padding(.vertical, 10)
                    
                    VStack(alignment: .leading) {
                        Text("저자 및 역자")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.bottom, 5)
                        
                        VStack(alignment: .leading){
                            if book.authors.isEmpty {
                                Text("저자를 찾을 수 없어요.")
                            } else {
                                // 작가가 여러명일수도 있어서 ForEach
                                ForEach(book.authors, id: \.self) { author in
                                    Text("\(author)")
                                }
                            }
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .padding(.bottom, 10)
                    
                    Text("카테고리")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text(book.bookCategory?.rawValue ?? "카테고리")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingExtensionSheet) {
            RentalExtensionSheet(rental: rental, isShowingExtensionSheet: $isShowingExtensionSheet)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isShowingReturnSheet) {
            RentalReturnSheet(rental: rental, isShowingReturnSheet: $isShowingReturnSheet)
                .presentationDetents([.medium])
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            // User Firebase Storage 경로 URL로 다운로드
            let storageRef = Storage.storage().reference(withPath: user.image ?? "profile/defaultUser")
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                } else if let url = url {
                    userImageUrl = url
                }
            }
            
            // Book 앞글자에 따라 imageURL에 할당하는 조건
            if book.thumbnail.hasPrefix("http://") || book.thumbnail.hasPrefix("https://") {
                bookImageUrl = URL(string: book.thumbnail)
            } else {
                // Firebase Storage 경로 URL 다운로드
                let storageRef = Storage.storage().reference(withPath: book.thumbnail)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        bookImageUrl = url
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RentalBookDetailView(book: Book(ownerID: "", ownerNickname: "닉네임", title: "책 제목", contents: "책 소개", authors: ["책 작가"], rentalState: .rentalAvailable), rental: Rental(id: "", bookOwner: "", bookID: "", rentalStartDay: Date(), rentalEndDay: Date(), map: "", mapDetail: "", latitude: 0, longitude: 0), user: User())
    }
}
