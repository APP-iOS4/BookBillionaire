//
//  AddRoomView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/8/24.
//

import SwiftUI
// 임시 테스트용 입니다
struct AddRoomView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var addRoomVM = AddRoomViewModel()
   
    var body: some View {
        VStack {
            
            Form {
                TextField("Enter name", text: $addRoomVM.name)
                TextField("Enter description", text: $addRoomVM.description)
                
            }
            
            Button("Save") {
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
