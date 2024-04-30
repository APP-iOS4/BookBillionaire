//
//  ChatListView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct ChatListView: View {
    @State private var isEditing: Bool = false
    @StateObject private var roomListVM = ChatListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                            NavigationLink(destination: ChatView(room: room, roomVM: roomListVM)) {
                                RoomCellView(room: room)
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
                roomListVM.getAllRooms()
            }
            
            .onAppear(perform: {
                roomListVM.getAllRooms()
            })
        case .loggedOut:
            UnlogginedView()
                .padding()
        }
    }
}


#Preview {
    ChatListView()
}


struct RoomCellView: View {
    var room: RoomViewModel
    var user: User = User()
    @EnvironmentObject var userService : UserService
    
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
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text("\(roomName(users: room.room.users))")
                        .lineLimit(1)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(UIColor.label))
                    
                    Spacer()
                    
                    Text(room.lastTimeStamp.formatted(date: .numeric, time: .shortened))
                        .font(.system(size: 10))
                        .foregroundColor(Color(.lightGray))
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("<\(room.room.book.title)>")
                        .lineLimit(1)
                        //.foregroundStyle(.black)
                        .font(.system(size: 14))
                    
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
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        
        Divider()
        
    }
    
    func roomName(users: [String]) -> String {
        for user in users {
            if user != userService.currentUser.id {
                return userService.loadUserByID(user).nickName
            }
        }
        return "사용자 이름없음"
    }
}

//#Preview {
//    ChatListView()
//}
