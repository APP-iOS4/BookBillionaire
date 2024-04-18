//
//  StarView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/18/24.
//

import SwiftUI

struct StarView: View {
    let filled: Bool

    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15, height: 15)
            .foregroundColor(filled ? .yellow : .gray)
    }
}

#Preview {
    StarView(filled: true)
}
