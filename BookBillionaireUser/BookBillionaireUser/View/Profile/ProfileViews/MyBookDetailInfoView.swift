//
//  MyBookDetailInfoView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/30/24.
//

import SwiftUI

struct MyBookDetailInfoView: View {
    @Binding var selectedTab: Int
    var body: some View {
        VStack {
            HStack {
                Text("보유 도서")
                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                Spacer()
                Text("빌린 도서")
                    .fontWeight(selectedTab == 1 ? .bold : .regular)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 1
                        }
                    }
                Spacer()
                Text("즐겨찾기")
                    .fontWeight(selectedTab == 2 ? .bold : .regular)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 2
                        }
                    }
            }
            .padding(EdgeInsets(top: 20, leading: 24, bottom: 0, trailing: 24))
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width / 3, height: 2)
                    .foregroundColor(.accent)
                    .offset(x: CGFloat(selectedTab) * (UIScreen.main.bounds.width / 3))
            }
            
            TabView(selection: $selectedTab) {
                Text("보유 도서 뷰")
                    .tag(0)
                Text("빌린 도서 뷰")
                    .tag(1)
                Text("즐겨찾기 뷰")
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

#Preview {
    MyBookDetailInfoView(selectedTab: .constant(1))
}


