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
                Text("\(RentalStateType.rentalAvailable.description)")
                    .tag(RentalStateType.rentalAvailable)
                Text("\(RentalStateType.rentalNotPossible.description)")
                    .tag(RentalStateType.rentalNotPossible)
            }
            .pickerStyle(.wheel)
            Button {
                isShowingSheet.toggle()
            } label: {
                Text("완료")
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
        }
        .padding()
    }
}

#Preview {
    RentalStateSheetView(isShowingSheet: .constant(false), rentalState: .constant(.rentalAvailable))
}
