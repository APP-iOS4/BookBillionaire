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
    @State var tempRentalState: RentalStateType = .rentalAvailable
    
    var body: some View {
        VStack {
            Picker("대여 가능 여부", selection: $tempRentalState) {
                Text("\(RentalStateType.rentalAvailable.description)")
                    .tag(RentalStateType.rentalAvailable)
                Text("\(RentalStateType.rentalNotPossible.description)")
                    .tag(RentalStateType.rentalNotPossible)
            }
            .pickerStyle(.wheel)
            .onAppear {
                tempRentalState = rentalState
            }
            RoundButton(text: "완료") {
                isShowingSheet.toggle()
                rentalState = tempRentalState
            }
        }
        .padding()
    }
}

#Preview {
    RentalStateSheetView(isShowingSheet: .constant(false), rentalState: .constant(.rentalAvailable))
}
