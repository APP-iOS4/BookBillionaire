//
//  ComplainView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI

struct ComplainView: View {
    @State private var TimeComplainCheck = false
    @State private var badWordsCheck = false
    @State private var badBookCheck = false
    @State private var userDirectInput = false
    @State private var userDirectInputText = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userService : UserService

    var user: String
    let room: RoomViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("\(roomName(users: room.room.users)) \n사용자를 신고하는 이유를 선택해주세요.")
                    .font(.title3)
                    .padding()
                    .padding(.bottom, 20)
                
                List {
                    HStack {
                        Text("거래 시간을 지키지 않았어요")
                        
                        Spacer()
                        
                        Button {
                            TimeComplainCheck.toggle()
                            if TimeComplainCheck {
                                badWordsCheck = false
                                badBookCheck = false
                                userDirectInput = false
                            }
                        } label: {
                            if TimeComplainCheck {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    HStack {
                        Text("욕설, 비방, 혐오표현을 해요")
                        
                        Spacer()
                        
                        Button {
                            badWordsCheck.toggle()
                            if badWordsCheck {
                                TimeComplainCheck = false
                                badBookCheck = false
                                userDirectInput = false
                            }
                        } label: {
                            if badWordsCheck {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    HStack {
                        Text("책의 상태가 좋지않아요")
                        
                        Spacer()
                        
                        Button {
                            badBookCheck.toggle()
                            if badBookCheck {
                                TimeComplainCheck = false
                                badWordsCheck = false
                                userDirectInput = false
                            }
                        } label: {
                            if badBookCheck {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    HStack {
                        Text("그 외 사유")
                        
                        Spacer()
                        
                        Button {
                            userDirectInput.toggle()
                            if userDirectInput {
                                badBookCheck = false
                                TimeComplainCheck = false
                                badWordsCheck = false
                            }
                        } label: {
                            if userDirectInput {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.accent)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    if userDirectInput {
                        VStack(alignment: .leading) { // VStack 추가
                            TextEditor(text: $userDirectInputText)
                                .frame(height: 200)
                                .padding(.horizontal) // 양쪽에 여백 추가
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 1))
                                .onChange(of: userDirectInputText) { newValue in
                                    if newValue.count > 200 {
                                        userDirectInputText = String(newValue.prefix(200))
                                    }
                                }
                            
                            HStack {
                                Spacer()
                                Text("\(userDirectInputText.count)/200") // 입력한 글자 수 표시
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 20)
                            }
                            HStack {
                                Spacer()
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationBarTitle("사용자 신고")
            .listStyle(.inset)
            .navigationBarItems(trailing:
                                    Button {
                // 신고하기 버튼 탭
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("신고하기")
                    .foregroundStyle(.red)
            })
        }
    }
    
    private func roomName(users: [String]) -> String {
        for user in users {
            if user != userService.currentUser.id {
                return userService.loadUserByID(user).nickName
            }
        }
        return "사용자 이름없음"
    }
}
