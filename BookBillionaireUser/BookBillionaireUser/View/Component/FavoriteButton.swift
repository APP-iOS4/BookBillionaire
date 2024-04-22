//
//  FavoriteButton.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/16/24.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSaveBook: Bool
    
    var body: some View {
        Image(systemName: isSaveBook ? "heart.fill" : "heart")
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .foregroundStyle(isSaveBook ? Color.red : Color.gray.opacity(0.3))
            .onTapGesture {
                isSaveBook.toggle()
            }
    }
}

#Preview {
    FavoriteButton(isSaveBook: .constant(false))
}
