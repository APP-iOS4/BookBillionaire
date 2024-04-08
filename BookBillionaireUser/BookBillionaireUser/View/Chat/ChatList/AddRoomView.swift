//
//  AddRoomView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/8/24.
//

import SwiftUI
// [테스트용] 방 생성 뷰 입니다 - 추후 삭제 예정
struct AddRoomView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var addRoomVM = AddRoomViewModel()
   
    var body: some View {
        VStack {
            Form {
                TextField("[임시] 이름", text: $addRoomVM.name)
                TextField("[임시] 설명", text: $addRoomVM.description)
            }
            
            Button("생성하기") {
                addRoomVM.createRoom {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("채팅방 만들기 [임시]")
    }
}

#Preview {
    AddRoomView()
}
