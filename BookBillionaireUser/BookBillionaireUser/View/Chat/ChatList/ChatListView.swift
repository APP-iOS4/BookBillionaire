//
//  ChatListView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(0..<1, id: \.self) { num in
                    // [임시] 윗줄 수정 예정
                    NavigationLink(destination: ChatView()) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.fill")
                            // [임시] 상대방 이미지 받아와서 넣어주기
                                .font(.system(size: 30))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1))
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading) {
                                Text("최준영")
                                // [임시] 상대방 이름 받아와서 넣어주기
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.bottom, 5)
                                Text("안녕하세요. 대여 희망합니다요")
                                // [임시] 가장 최근 메세지 넣어주기
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            VStack() {
                                Text("오전 9:15분")
                                // [임시] 가장 최근 메세지 timestamp 넣어주기
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(.lightGray))
                                
                                Image(systemName: "1.circle.fill")
                                // [임시] if 문 때려서 읽음 안읽음 표시
                                // 안읽음이면 안읽은 메세지 몇 개인지 표시
                                // 주황 원에 숫자 넣은 커스텀 뷰 생성
                                // 읽음 표시와 안읽음 표시 방법 해결하고 여기 덤비기
                                    .foregroundColor(.orange)
                                    .font(.system(size: 20))
                                    .padding(.leading, 30)
                                    .padding(.top, 2)
                            }
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                .navigationTitle("채팅")
                .navigationBarTitleDisplayMode(.inline)
                // [추가 예정 기능]
                // 우측 상단 edit 버튼 추가하여 목록 삭제 기능 구현
                // 최근에 온 메세지를 상단으로 이동
            }
        }
    }
}

#Preview {
    ChatListView()
}
