//
//  SpaceBox.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/6/24.
//

import SwiftUI

/// 마진을 주기위한 공간 배치용 박스
struct SpaceBox: View {
    var body: some View {
        Rectangle()
            .frame(height: 30)
            .foregroundStyle(.clear)
    }
}

#Preview {
    SpaceBox()
}
