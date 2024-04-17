//
//  BottomSheetView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 3/24/24.
//

import SwiftUI

// 신고사유
enum RentalReportReason: String, CaseIterable {
    case inappropriateContent = "부적절한 콘텐츠"
    case falseInformation = "허위 정보"
    case damageOrMisuse = "손상 또는 남용"
    case lateReturn = "늦은 반납"
    case unauthorizedDistribution = "무단 배포"
    case misuseOfInformation = "정보 남용"
    case inappropriateLanguageOrDiscomfortingBehavior = "부적절한 언어 또는 불쾌한 행동"
}

struct BottomSheet: View {
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center){
                Text("신고")
                    .font(.title3)
            }
    
            Divider()
                .background(Color.gray)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("회원님의 신고는 익명으로 처리되어 관리자에게 접수되며 개인정보는 안전하게 보호됩니다.")
                    .font(.caption)
                
                Divider()
                    .background(Color.gray)
                    .padding(.vertical, 15)
                
                Text("게시물을 신고하는 이유를 알려주세요!")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                ForEach(RentalReportReason.allCases, id: \.self) {
                    reason in
                    HStack(alignment: .center) {
                        Text(reason.rawValue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                        .padding(.trailing)
                    }
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.vertical, 15)
                }
            }
        }
        .padding()
    }
}

#Preview {
    BottomSheet(isShowingSheet: .constant(true))
}
