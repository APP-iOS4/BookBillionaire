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
        VStack(alignment: .leading) {
            Text(book.title)
                .multilineTextAlignment(.leading)
                .bold()
                .padding(.bottom, 5)
            Text("소유자: "+book.ownerNickname)
            ZStack {
                Capsule()
                    .stroke(Color.accentColor)
                    .frame(height: 25)
                Text( book.bookCategory?.buttonTitle ?? "카테고리 미설정")
                    .padding(.horizontal)
            }
            .fixedSize()
        }
        Divider()
    }
}


#Preview {
    GridCellInfo(book: Book(ownerID: "BC1s1IexScXtGBnrIoSgzzQJDRI2", ownerNickname: "UDI", title: "월간 커피(2022년 10월호)", contents: "커피 전문 잡지로, 커피에 대한 정보를 소개하는 것에 그치지 않고 전반적인 커피 시장에 대해 다루고 있으며 성공적인 운영 노하우 등을 공유한다.", authors: ["아이비라인 편집부"], rentalState: .rentalAvailable))
}

