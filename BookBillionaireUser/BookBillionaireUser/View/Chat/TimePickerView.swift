//
//  TimePickerView.swift
//  BookBillionaire
//
//  Created by 최준영 on 3/20/24.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date
    @State var testTime: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DatePicker("",selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding(.horizontal, 40)
                .padding(.top, 15)
                
        }
            Button("확인") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(AccentButtonStyle())
            .padding(.horizontal, 30)
        
        Spacer()

    }
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


#Preview {
    TimePickerView(selectedTime: .constant(Date()))
}
