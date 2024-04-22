//
//  ChatListView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI

struct ChatListView: View {
    @State private var isEditing: Bool = false
    @StateObject private var roomListVM = ChatListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    let userId = AuthViewModel.shared.currentUser?.uid ?? ""
    
    var body: some View {
        switch authViewModel.state {
        case .loggedIn:
            VStack {
                if roomListVM.rooms.isEmpty {
                    Text("참여한 대화방이 없습니다.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(roomListVM.rooms, id: \.room.self) { room in
                            NavigationLink(destination: ChatView(room: room)) {
                                RoomCell(room: room)
                            }
                            Divider()
                        }
                    }
                    .padding(.top, 15)
                }
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                roomListVM.getAllRooms(userId: userId)
            }
            
            .onAppear(perform: {
                roomListVM.getAllRooms(userId: userId)
            })
        case .loggedOut:
            UnlogginedView()
                .padding()
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
                HStack(alignment: .top) {
                    Text(room.receiverName)
                        .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                    
                    Spacer()
                    
                    Text(room.lastTimeStamp.formatted(date: .numeric, time: .shortened))
                        .font(.system(size: 10))
                        .foregroundColor(Color(.lightGray))
                }
                HStack {
                    if room.lastMessage.hasPrefix("https://firebasestorage") {
                        Text("사진")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                            .lineLimit(1)
                    } else {
                        Text(room.lastMessage)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        //[임시] 안 읽은 메세지 숫자
                        Capsule()
                            .fill(Color.orange)
                            .frame(width: 35, height: 25)
                        Text("1")
                            .foregroundColor(.white)
                            .font(Font.system(size: 12, weight: .bold))
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        
        Divider()
    }
}

#Preview {
    ChatListView()
}
