//
//  CustomAlertView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 3/22/24.
//

import SwiftUI
// 페이지별로 필요한 값 입력해서
// 적용하면 될 거 같아요

// 알림에 들어갈 타이틀과 설명
enum AlertType {
    case deleteBook
    case overChat
    case limitText
    case login
    
    // Title 문구
    var title: String {
        switch self {
        case .deleteBook:
            return "이 책을 정말로 삭제할까요?"
        case .overChat:
            return "채팅방을 나가시겠습니까?"
        case .limitText:
            return "글자 수 입력 제한 초과!"
        case .login:
            return "로그인이 필요해요!"
        }
    }

    // Description 문구
    var notice: String {
        switch self {
        case .deleteBook:
            return "한 번 삭제하면 되돌릴 수 없어요. 계속할까요?"
        case .overChat:
            return "채팅을 나가면 상대방과의 대화가 종료돼요."
        case .limitText:
            return "글자 수가 너무 많아서 초과된 부분은 자동으로 삭제될 거예요."
        case .login:
           return "로그인하면 이 컨텐츠를 이용할 수 있어요."
        }
    }
}

struct CustomAlert: View {
    @Environment(\.colorScheme) var colorScheme
    var alertType: AlertType // Enum
    var onConfirm: () -> Void
    var customAlertBackgroundColor: Color {
        colorScheme == .dark ? Color("BGColor") : Color.white
    }


    @Binding var isShowingCustomAlert: Bool

    var body: some View {
            defaultAlart
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//
//#Preview {
//    CustomAlert(alertType: .overChat, isShowingCustomAlert: .constant(true))
//}

// MARK: - Alert
extension CustomAlert {
    var defaultAlart: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text(alertType.title)
                    .font(.title3)
                    .padding(.bottom, 5)
                
                Text(alertType.notice)
                    .font(.body)
                    .foregroundStyle(.gray)
                    .padding(.bottom)
                
                HStack {
                    Button {
                        isShowingCustomAlert.toggle()
                    } label: {
                        Text("취소")
                    }
                    .buttonStyle(WhiteButtonStyle(height: 50.0))
                    
                    Button {
                      onConfirm()
                    } label: {
                        Text("확인")
                    }
                    .buttonStyle(AccentButtonStyle(height: 50.0))
                }
                
            }
            .padding(EdgeInsets(top: 40, leading: 30, bottom: 40, trailing: 30))
            .background(customAlertBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        }
    }
}
