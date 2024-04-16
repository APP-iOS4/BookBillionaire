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
    case deleteList
    case hidePost
    
    // Title 문구
    var title: String {
        switch self {
        case .deleteList:
            return "정말로 이 항목을 삭제하시겠습니까?"
        case .hidePost:
            return "게시물을 보관합니다."
        }
        
    }
    // Description 문구
    var notice: String {
        switch self {
        case .deleteList:
            return "한번 삭제한 항목은 되돌릴 수 없습니다."
        case .hidePost:
            return "게시물을 보관합니다."
        }
    }
}

struct CustomAlert: View {
    @Environment(\.colorScheme) var colorScheme
    
    var customAlertBackgroundColor: Color {
        colorScheme == .dark ? Color("BGColor") : Color.white
    }
    
    
    var alertType: AlertType // Enum
    
    @Binding var isShowingDefualtAlert: Bool
    @State var isShowingConfirmAlert: Bool = false
    
    // 상황별 confirm 문구
    var confirmText: String {
        switch alertType {
        case .deleteList:
            return "항목이 삭제 되었습니다."
        case .hidePost:
            return "게시물을 보관하였습니다."
        }
    }
    
    var body: some View {
        
        if isShowingConfirmAlert {
            confirmAlert
            
        } else if alertType == .hidePost {
            confirmAlert
        }
        
        else {
            defaultAlart
        }
        
        
        
    }
}



#Preview {
    CustomAlert(alertType: .hidePost, isShowingDefualtAlert: .constant(true))
}

// MARK: - 선택 Alert
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
                        isShowingDefualtAlert.toggle()
                    } label: {
                        Text("취소")
                    }
                    .buttonStyle(WhiteButtonStyle(height: 50.0))
                    
                    Button {
                        isShowingConfirmAlert = true
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

// MARK: - 확인 Alert
extension CustomAlert {
    var confirmAlert: some View {
        ZStack {
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text(confirmText)
                    .font(.title3)
                    .padding(.bottom)
                
                Button {
                    isShowingDefualtAlert = false
                    isShowingConfirmAlert.toggle()
                } label: {
                    Text("확인")
                }
                .buttonStyle(AccentButtonStyle(height: 50.0))
                
            }
            .padding(EdgeInsets(top: 40, leading: 30, bottom: 40, trailing: 30))
            .background(customAlertBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
        }
    }
}
