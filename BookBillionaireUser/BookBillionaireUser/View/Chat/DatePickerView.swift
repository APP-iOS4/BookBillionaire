//
//  DatePickerView.swift
//  BookBillionaire
//
//  Created by 최준영 on 3/20/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            Button("확인") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(AccentButtonStyle())
            .padding(.horizontal, 30)
            SpaceBox()
        }
        Spacer()
    }
}
//
//#Preview {
//    DatePickerView()
//}
