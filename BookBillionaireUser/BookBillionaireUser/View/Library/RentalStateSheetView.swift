//
//  RentalStateSheetView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/4/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalStateSheetView: View {
    @Binding var isShowingSheet: Bool
    @Binding var rentalState: RentalStateType
    
    var body: some View {
        VStack {
            Picker("대여 가능 여부", selection: $rentalState) {
                Text("\(RentalStateType.rentalAvailable.rawValue)")
                    .tag(RentalStateType.rentalAvailable)
                Text("\(RentalStateType.rentalNotPossible.rawValue)")
                    .tag(RentalStateType.rentalNotPossible)
            }
            .pickerStyle(.wheel)
            Button("완료") {
                isShowingSheet.toggle()
            }
            .buttonStyle(AccentButtonStyle())
            .padding()
        }
        .padding()
    }
}

#Preview {
    RentalStateSheetView(isShowingSheet: .constant(false), rentalState: .constant(.rentalAvailable))
}
