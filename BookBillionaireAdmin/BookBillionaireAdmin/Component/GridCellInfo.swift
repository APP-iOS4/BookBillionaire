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
                VStack{
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
                    Text(book.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .bold()
            }
                .padding()
        }
        .padding()
    }
}

