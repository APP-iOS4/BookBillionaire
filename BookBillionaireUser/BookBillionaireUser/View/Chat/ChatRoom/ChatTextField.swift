//
//  ChatTextField.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/7/24.
//

import SwiftUI

struct ChatTextField: View {
    @State private var plusItemShowing = false
    @State private var message = ""
    
    @EnvironmentObject var MessageListViewModel: MessageListViewModel

    var body: some View {
        HStack {
            Button {
                plusItemShowing.toggle()
                hideKeyboard()
            } label: {
                plusItemShowing ? Image(systemName: "xmark") : Image(systemName: "plus")
            }
//                .transition(.move(edge: .bottom))
            .padding(.horizontal,10)
            
            
            TextField("메세지를 입력하세요.", text: $message)
                .padding(15)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)
            
            Button {
//                MessageListViewModel.sendMessage(msg: MessageViewState(message: message, roomId: <#T##String#>, username: <#T##String#>), completion: <#T##() -> Void#>)
                message = ""
            } label: {
                ZStack {
                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                        .foregroundColor(.accentColor)
                    Image(systemName: "paperplane")
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
            }
        }
        .padding(.bottom, 8)
        .padding(.top, 0.2)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(50)
        
        if plusItemShowing {
            ChatPlusItem()
                .padding(.bottom, 50)
                .padding(.top, 30)
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ChatTextField()
}
