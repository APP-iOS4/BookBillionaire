//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct Rental: Identifiable, Codable{
    public var id: String
    public var bookOwner: String
    public var bookBorrower: String?
    public var rentalStartDay: Date
    public var rentalEndDay: Date
    public var rentalTime: Date?
    public var map: String
    
    public init() {
        self.id = UUID().uuidString
        self.bookOwner = ""
        self.bookBorrower = ""
        self.rentalStartDay = Date()
        self.rentalEndDay = Date()
        self.rentalTime = Date()
        self.map = ""
    }
    
    public init(id: String, bookOwner: String, bookBorrower: String? = nil, rentalStartDay: Date, rentalEndDay: Date, rentalTime: Date? = nil, map: String) {
        self.id = UUID().uuidString
        self.bookOwner = bookOwner
        self.bookBorrower = bookBorrower
        self.rentalStartDay = rentalStartDay
        self.rentalEndDay = rentalEndDay
        self.rentalTime = rentalTime
        self.map = map
    }
}
