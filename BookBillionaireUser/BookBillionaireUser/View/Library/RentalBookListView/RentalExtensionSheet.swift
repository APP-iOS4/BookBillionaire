//
//  RentalExtensionSheet.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 5/1/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalExtensionSheet: View {
    var rental: Rental
    @State private var extensionDate: Date = Date()
    @State private var extensionPeriod: Int = 1
    @Binding var isShowingExtensionSheet: Bool

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("대여 연장일", selection: $extensionDate, in: Date()..., displayedComponents: [.date])
                Stepper(value: $extensionPeriod, in: 1...30) {
                    Text("대여 연장 기간: \(extensionPeriod)일")
                }
                Button("완료") {
                    // 대여 연장 정보를 저장하는 코드
                    isShowingExtensionSheet.toggle()
                }
                .buttonStyle(AccentButtonStyle(height: 50))
            }
            .padding()
            .navigationTitle("대여 연장")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isShowingExtensionSheet.toggle()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
    }
}

#Preview {
    RentalExtensionSheet(rental: Rental(), isShowingExtensionSheet: .constant(false))
}
