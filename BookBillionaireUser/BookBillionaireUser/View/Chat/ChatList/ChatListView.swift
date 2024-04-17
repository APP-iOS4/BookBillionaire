//
//  ChatListView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI

struct ChatListView: View {
    @State private var isEditing: Bool = false
    @StateObject private var roomListVM = RoomListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        switch authViewModel.state {
        case .loggedIn:
            VStack {
                ScrollView {
                    ForEach(roomListVM.rooms, id: \.room.self) { room in
                        NavigationLink(destination: ChatView(room: room)) {
                            RoomCell(room: room)
                        }
                        Divider()
                    }
                }
                .padding(.top, 15)
                .refreshable {
                    roomListVM.getAllRooms()
                }
                .navigationTitle("채팅")
                .navigationBarTitleDisplayMode(.inline)
                
                .onAppear(perform: {
                    roomListVM.getAllRooms()
                })
            }
        case .loggedOut:
            UnlogginedView()
        }
    }
}

struct RoomCell: View {
    
    let room: RoomViewModel

    var body: some View {
        HStack {
            ZStack {
                // [임시] 상대방 이미지 받아와서 넣어주기
                Image("defaultUser")
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            }
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(room.receiverName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                
                Text(room.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                Text(room.lastTimeStamp.formatted(date: .numeric, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundColor(Color(.lightGray))
                    .padding(.bottom, 30)
            }
//             후순위 :
//             [임시] 안 읽은 메세지 숫자
//            Image(systemName: "1.circle.fill")
//                .foregroundColor(.orange)
//                .font(.system(size: 23))
        }
        .padding(.horizontal, 15)
        
        Divider()
    }
}

#Preview {
    ChatListView()
}
