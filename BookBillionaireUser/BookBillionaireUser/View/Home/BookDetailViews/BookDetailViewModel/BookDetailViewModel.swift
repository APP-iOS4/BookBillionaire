//
//  BookDetailViewModel.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import Foundation
import BookBillionaireCore

class BookDetailViewModel: ObservableObject {
    @Published var book: Book
    @Published var user: User
    @Published var rentalTime: (Date, Date) = (Date(), Date())
    @Published var rental: Rental
    private let rentalService: RentalService
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    
    init(book: Book, user: User, rental: Rental, rentalService: RentalService) {
        self.book = book
        self.user = user
        self.rental = rental
        self.rentalService = rentalService
        fetchRentalInfo()
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
    
    
    func fetchRentalInfo() {
        Task {
            let (startDate, endDate) =  await rentalService.getRentalDay(rental.id)
            rentalTime = (startDate, endDate)
        }
    }
    
}
