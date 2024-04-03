//
//  RentalPeriodView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalPeriodView: View {
    @State var rental: Rental
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("대여 가능 기간 설정")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .fontWeight(.medium)
            DatePicker("대여 시작 기간", selection: $rental.rentalStartDay, in: Date()..., displayedComponents: [.date])
            DatePicker("대여 종료 기간", selection: $rental.rentalEndDay, in: rental.rentalStartDay..., displayedComponents: [.date])
        }
        .padding()
    }
}

#Preview {
    RentalPeriodView(rental: Rental(id: "", bookOwner: "", rentalState: .rentalAvailable, rentalStartDay: Date(), rentalEndDay: Date()))
}
