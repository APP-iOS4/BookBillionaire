//
//  BottomSheetView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 3/24/24.
//

import SwiftUI

struct BottomSheet: View {

    @Binding var isShowingSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    Button {
                        
                    } label: {
                        Label("게시물 숨기기", systemImage: "eye.slash")

                    }
                    .foregroundStyle(.primary)

                }
                
                Section {
                    Button {
                        isShowingSheet = false
                    } label: {
                        Text("닫기")
                    }
                    .foregroundStyle(.primary)
                }
            }
            .scrollDisabled(true)
            
        }
        
    }
}

#Preview {
    BottomSheet(isShowingSheet: .constant(true))
}
