//
//  GridCell.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import BookBillionaireCore

struct GridCell: View {
    var book: Book
    @State private var loadedImage: UIImage?
    @State var isToggle: Bool = false
    @Binding var selectedBooks: [Book]
    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(isToggle ? Color.accentColor : Color.bbBGcolor)
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
                    Text(book.id)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .bold()
            }
                .padding()
        }
        .padding()
        .onTapGesture {
            isToggle.toggle()
            if isToggle {
                selectedBooks.append(book)
            } else {
                if selectedBooks.contains(book) {
                    selectedBooks.removeAll(where: { $0 == book })
                }
            }
            print("\(selectedBooks)")
        }
    }
}

