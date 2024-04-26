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
    @State var book: Book
    @State var rental: Rental
    let imageChache = ImageCache.shared
    @State private var imageUrl: URL?
    @State private var loadedImage: UIImage?
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let url = imageUrl, !url.absoluteString.isEmpty {
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
                    VStack(alignment: .leading) {
                        Text("책 소유자: \(book.ownerNickname)")
                        Text("대여 기간: \(dateFormatter.string(from: rental.rentalStartDay)) ~ \(dateFormatter.string(from: rental.rentalEndDay))")
                    }
                    .font(.headline)
                    Spacer()
                }
                HStack {
                    Button("대여 연장") {
                        
                    }
                    .padding()
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
                    
                    Button("대여 반납") {
                        
                    }
                    .padding()
                    .background(Capsule().fill(Color.red))
                    .foregroundColor(.white)
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("기본 정보")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("책 소개")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .padding(.bottom, 3)
                    Text(book.contents)
                        .lineSpacing(5)
                        .font(.caption)
                    Divider()
                        .padding(.vertical, 10)
                    
                    VStack(alignment: .leading) {
                        Text("저자 및 역자")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.bottom, 5)
                        
                        HStack(alignment: .center){
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
                    .font(.caption)
                    .padding(.bottom, 10)
                    
                    Text("카테고리")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text(book.bookCategory?.rawValue ?? "카테고리")
                        .font(.caption)
                }
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 앞글자에 따라 imageURL에 할당하는 조건
            if book.thumbnail.hasPrefix("http://") || book.thumbnail.hasPrefix("https://") {
                imageUrl = URL(string: book.thumbnail)
            } else {
                // Firebase Storage 경로 URL 다운로드
                let storageRef = Storage.storage().reference(withPath: book.thumbnail)
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        imageUrl = url
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RentalBookDetailView(book: Book(ownerID: "", ownerNickname: "닉네임", title: "책 제목", contents: "책 소개", authors: ["책 작가"], rentalState: .rentalAvailable), rental: Rental(id: "", bookOwner: "", bookID: "", rentalStartDay: Date(), rentalEndDay: Date(), map: "", mapDetail: "", latitude: 0, longitude: 0))
    }
}
