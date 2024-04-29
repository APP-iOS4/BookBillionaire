//
//  BookDetailViewModel.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import Foundation
import BookBillionaireCore

class BookDetailViewModel: ObservableObject {
    @Published var rentalTime: (Date, Date) = (Date(), Date())
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    
    func calculateTotalDays() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: rentalTime.0, to: rentalTime.1)
        return components.day ?? 0
    }
    
    func formattedRentalTime() -> String {
        let startDateString = dateFormatter.string(from: rentalTime.0)
        let endDateString = dateFormatter.string(from: rentalTime.1)
        let totalDays = calculateTotalDays()
        return "\(startDateString) - \(endDateString) (\(totalDays)일)"
    }

}

