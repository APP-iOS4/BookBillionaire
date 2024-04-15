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
                // 대화방 삭제 기능 구현
                ScrollView {
                    ForEach(roomListVM.rooms, id: \.room.self) { room in
                        NavigationLink(value: room){
                            RoomCell(room: room)}
                        Divider()
                    }
                    .navigationDestination(for: RoomViewModel.self){ room in
                        ChatView(room: room)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .padding(.top, 15)
            .refreshable {
                roomListVM.getAllRooms()
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationBarItems(trailing: Button {
                isEditing = true
            } label: {
                Image(systemName: "plus.app")
            })
            
            .sheet(isPresented: $isEditing, onDismiss: {
                
            }, content: {
                AddRoomView()
            })
            
            .onAppear(perform: {
                roomListVM.getAllRooms()
                
            })
        case .loggedOut:
            UnlogginedView()
        }
    }
}

struct RoomCell: View {
    
    let room: RoomViewModel
//    let messageViewState: MessageViewState
    // 파이어베이스에 올라간 목록들을 여기서 어떻게 보여주는지 모르겠다.
    var body: some View {
        HStack {
            ZStack {
                // [임시] 상대방 이미지 받아와서 넣어주기
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 50, height: 50)
                    .opacity(0.7)
                Image(systemName: "figure.arms.open")
                    .padding(8)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(room.receiverName)
                    .font(.system(size: 16, weight: .bold))
                
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
            // 후순위 :
            // [임시] 안 읽은 메세지 숫자
//            Image(systemName: "1.circle.fill")
//                .foregroundColor(.orange)
//                .font(.system(size: 23))
        }
        .padding(.horizontal, 15)
        
        Divider()
    }
}

#Preview {
//    RoomCell(room: RoomViewModel(room: Room(receiverName: "최준영", lastTimeStamp: Date(), lastMessage: "gg", users: ["",""])))
    ChatListView()
}
