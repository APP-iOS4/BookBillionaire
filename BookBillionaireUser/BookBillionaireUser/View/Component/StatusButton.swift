//
//  StatusButtonView.swift
//  BookBillionareUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct StatusButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var status: RentalStateType
    
    
    var statusButtonColor: Color {
        switch status {
        case .renting:
            return Color.orange
        case .rentalNotPossible:
            return Color.red
        case .rentalAvailable:
            return Color("SecondColor")
        }
    }
    
    var statusButtonBackgroundColor: Color {
        colorScheme == .dark ? statusButtonColor : Color.clear
    }
    
    var statusButtonBorderColor: Color {
        colorScheme == .dark ? statusButtonColor : Color.clear
    }
    
    var statusButtonForegroundColor: Color {
        colorScheme == .dark ? .white : statusButtonColor
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(statusButtonColor)
                .background(
                    Capsule()
                        .fill(statusButtonBackgroundColor)
                        .opacity(0.3)
                )
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
    StatusButton(status: .rentalAvailable)
}
