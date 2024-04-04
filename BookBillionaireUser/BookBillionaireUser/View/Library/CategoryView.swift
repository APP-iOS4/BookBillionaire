//
//  CategoryView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedIndex: Int
    @State private var selectedCategory: String = "보유도서"
    var categories = ["보유도서", "빌린도서"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                    Text("\(category)")
                        .padding(.vertical, 20)
                        .fontWeight(.medium)
                        .foregroundStyle(selectedCategory == category ? Color.accentColor : .black)
                        .overlay {
                            if selectedCategory == category {
                                VStack {
                                    Spacer()
                                    Rectangle()
                                        .frame(height: 2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedIndex = index
                                selectedCategory = category
                            }
                        }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray.opacity(0.3))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        .background(Rectangle().foregroundStyle(.white))
    }
}

#Preview {
    CategoryView(selectedIndex: .constant(0))
}
