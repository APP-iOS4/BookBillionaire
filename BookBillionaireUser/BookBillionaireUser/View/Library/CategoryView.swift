//
//  CategoryView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedIndex: Int
    @State private var selectedCategory: Category = .myBook
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                ForEach(Array(Category.allCases.enumerated()), id: \.element) { index, category in
                    Text(category.rawValue)
                        .padding(.vertical, 20)
                        .fontWeight(.medium)
                        .foregroundStyle(selectedCategory == category ? Color.accentColor : Color.primary)
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
    }
}

#Preview {
    CategoryView(selectedIndex: .constant(0))
}

enum Category: String, CaseIterable {
    case myBook = "보유도서"
    case rentalBook = "빌린도서"
}
