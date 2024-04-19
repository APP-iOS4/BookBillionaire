//
//  MenuScrollView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/18/24.
//

import SwiftUI
import BookBillionaireCore

struct MenuScrollView: View {
    @Binding var menuTitle: BookCategory
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(BookCategory.allCases, id: \.self) { menu in
                        Button {
                            withAnimation {
                                menuTitle = menu
                                proxy.scrollTo(menu, anchor: .center)
                            }
                        } label: {
                            Text("\(menu.buttonTitle)")
                                .fontWeight(menuTitle == menu ? .bold : .regular)
                                .foregroundStyle(menuTitle == menu ? .white : .black)
                                .minimumScaleFactor(0.5)
                                .frame(width: 70, height: 20)
                        }
                        .padding(10)
                        .background(menuTitle == menu ? Color("AccentColor") : Color("SecondColor").opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}

#Preview {
    MenuScrollView(menuTitle: .constant(.hometown))
}
