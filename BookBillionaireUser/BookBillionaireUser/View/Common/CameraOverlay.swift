//
//  CameraOverlay.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/15/24.
//

import SwiftUI

struct CameraOverlay: View {
    var body: some View {
        Image(systemName: "camera.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30) // 카메라 아이콘의 크기를 조정합니다.
            .background(Color.white) // 아이콘의 배경색을 흰색으로 설정합니다.
            .clipShape(Circle()) // 아이콘을 원형으로 만듭니다.
            .offset(x: 5, y: 5) // 아이콘의 위치를 조정합니다.
    }
}
