//
//  StatusButtonView.swift
//  BookBillionareUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct StatusButton: View {
    
    var status: RentalStateType

        var statusButtonColor: Color {
            switch status {
            case .renting:
                return Color.orange
            case .rentalNotPossible:
                return Color.red
            case .rentalAvailable:
                return Color("SecondaryColor")
            }
        }
        
        var statusButtonForegroundColor: Color {
            switch status {
            case .renting:
                return Color.orange
            case .rentalNotPossible:
                return Color.red
            case .rentalAvailable:
                return Color("SecondaryColor")
            }
        }
        
        var body: some View {
            ZStack {
                Capsule()
                    .stroke(statusButtonColor)
                    .background(Color.clear)
                    .frame(height: 25)
                Text(status.rawValue)
                    .font(.system(size: 12))
                    .foregroundStyle(statusButtonForegroundColor)
                    .padding()
            }
            .fixedSize()
        }
    }

#Preview {
    StatusButton(status: .renting)
}
