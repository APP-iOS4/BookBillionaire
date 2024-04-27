//
//  CameraOverlay.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/15/24.
//

import SwiftUI

struct OverlayImage: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accentColor)
                        .frame(width: 30, height: 30)
                )
                .frame(width: 35, height: 35)
        }
        .offset(x: 5, y: 5)
    }
}

