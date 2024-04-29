//
//  NoticeView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import SwiftUI

struct NoticeView: View {
    var menuType: SettingMenuType
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(dummyNotice) {
                    notice in NoticeItem(notice: notice)
                }
            }
            .navigationTitle(menuType.rawValue)
        }
    }
}

#Preview {
    NoticeView(menuType: .notice)
}
