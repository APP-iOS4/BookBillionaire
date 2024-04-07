//
//  ChatPlusItem.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI

struct ChatPlusItem: View {
    var body: some View {
        HStack {
            GridRow {
                VStack{
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .foregroundColor(.accentColor)
                        Image(systemName: "photo.fill")
                            .foregroundColor(.white)
                    }
                    .frame(width: 50, height: 40)
                    
                    Text("사진보내기")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.trailing, 40)
            
            GridRow {
                Button {
                    // 맵 뷰로 이동
                } label: {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.gray)
                            Image(systemName: "map")                    .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 40)
                        
                        Text("장소공유")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.trailing, 40)
            
            GridRow {
                Button {
                    // 신고 뷰로 이동
                } label: {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                .foregroundColor(.red)
                            Image(systemName: "light.beacon.max.fill")                    .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 40)
                        
                        Text("신고하기")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}


#Preview {
    ChatPlusItem()
}
