//
//  BoxView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/26/24.
//

import SwiftUI

struct CountBoxView: View {
    var title: String
    var count: Int
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundStyle(Color.accentColor)
            VStack{
                Text(title)
                    .font(.title)
                Text("\(count)")
            }
        }
    }
}

#Preview {
    CountBoxView(title: "유저수", count:100)
}
