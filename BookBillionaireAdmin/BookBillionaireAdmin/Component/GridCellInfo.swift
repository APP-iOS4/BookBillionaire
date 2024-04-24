//
//  GridCellInfo.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import BookBillionaireCore

struct GridCellInfo: View {
    var book: Book
    @State private var loadedImage: UIImage?
    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.bbBGcolor)
                    .frame(width: 550, height: 200)
                HStack(spacing: 50){
                    if let url = URL(string: book.thumbnail), !url.absoluteString.isEmpty {
                        Image(uiImage: loadedImage ?? UIImage(named: "default")!)
                            .resizable()
                            .frame(width: 120, height: 140)
                            .scaledToFill()
                            .onAppear {
                                ImageCacheService.shared.getImage(for: url) { image in
                                    loadedImage = image
                                }
                            }
                    } else {
                        Image("default")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 140)
                    }
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .bold()
                        Text("소유자: "+book.ownerNickname)
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(style: StrokeStyle())
                                    .frame(width:150, height: 30)
                                Text("\(String(describing: book.bookCategory))")
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(style: StrokeStyle())
                                    .frame(width:150, height: 30)
                                Text("\(String(describing: book.rentalState.rawValue))")
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .padding()
        }
}

#Preview {
    GridCellInfo(book: Book(ownerID: "BC1s1IexScXtGBnrIoSgzzQJDRI2", ownerNickname: "UDI", title: "월간 커피(2022년 10월호)", contents: "커피 전문 잡지로, 커피에 대한 정보를 소개하는 것에 그치지 않고 전반적인 커피 시장에 대해 다루고 있으며 성공적인 운영 노하우 등을 공유한다.", authors: ["아이비라인 편집부"], rentalState: .rentalAvailable))
}

