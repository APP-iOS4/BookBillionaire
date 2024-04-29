//
//  ComplainView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/24/24.
//

import SwiftUI
import BookBillionaireCore

struct ComplainView: View {
    var topic: Topic
    @State private var result: [User] = []
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ZStack{
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width / 3)
                    VStack{
                        
                    }
                }
                ZStack{
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2 * geometry.size.width / 3)
                }
            }
        }
    }
}
