//
//  SettingButtonView.swift
//  Practice00
//
//  Created by 홍승표 on 3/9/24.
//

import SwiftUI

struct SettingButton: View {
    @State private var isGoToNotice: Bool = false
    @State private var isGoToQandA: Bool = false
    @State private var isGoToPolicy: Bool = false
    @Binding var sholudLogout: Bool
    var buttonType: SettingMenuType
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    handleButtonTap()
                } label: {
                    Text("\(buttonType.rawValue)")
                        .font(.body)
                }
                .tint(.primary)
            }
            .padding(.vertical, 10)
        }
        .navigationDestination(isPresented: $isGoToNotice) {
            NoticeView(menuType: .notice)
        }
        .navigationDestination(isPresented: $isGoToQandA) {
            QAView()
        
        }
        .navigationDestination(isPresented: $isGoToPolicy) {

        }
    }
    
    private func handleButtonTap() {
        switch buttonType {
        case .notice:
            isGoToNotice = true
        case .qanda:
            isGoToQandA = true
        case .policy:
            isGoToPolicy = true
        case .logout:
            sholudLogout = true
        }
    }
}

#Preview {
    SettingButton(sholudLogout: .constant(false), buttonType: .notice)
}
