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
    
    var body: some View {
        NavigationStack {
            VStack {
                List(roomListVM.rooms, id: \.room.self) { room in
                    NavigationLink(value: room){
                        RoomCell(room: room)}
                }
                .navigationDestination(for: RoomViewModel.self){ room in
                    ChatView(room: room)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationBarItems(trailing: Button {
                isEditing = true
            } label: {
                Text("Edit")
            })
            
            .sheet(isPresented: $isEditing, onDismiss: {
                
            }, content: {
                AddRoomView()
            })
            
            .onAppear(perform: {
                roomListVM.getAllRooms()
            })
        }
    }
}

struct RoomCell: View {
    
    let room: RoomViewModel
    
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
                Text(room.name)
                    .font(.system(size: 16, weight: .bold))
                Text(room.description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.lightGray))
            }
            
            Spacer()
            
            HStack(alignment: .top) {
            // [임시] 마지막 채팅 시간 넣어주기
                Text("오전 9:15분")
                    .font(.system(size: 10))
                    .foregroundColor(Color(.lightGray))
                    .padding(.bottom, 30)
            }
            // [임시] 안 읽은 메세지 숫자
            Image(systemName: "1.circle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 23))
        }
        .padding(.horizontal, 15)
        
        Divider()
    }
}

#Preview {
    RoomCell(room: RoomViewModel(room: Room(name: "최준영", description: "책 대여 블라블라 어쩌구 저쩌구")))
//    ChatListView()
}
