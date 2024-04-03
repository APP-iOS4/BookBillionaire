//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct Rental: Identifiable, Codable{
    public var id: String = UUID().uuidString
    public var bookOwner: String
    public var bookBorrower: String?
    public var rentalState: RentalStateType
    public var rentalStartDay: Date
    public var rentalEndDay: Date
    public var rentalTime: Date?
    public var map: String?
    
    public init(id: String, bookOwner: String, bookBorrower: String? = nil, rentalState: RentalStateType, rentalStartDay: Date, rentalEndDay: Date, rentalTime: Date? = nil, map: String? = nil) {
        self.id = id
        self.bookOwner = bookOwner
        self.bookBorrower = bookBorrower
        self.rentalState = rentalState
        self.rentalStartDay = rentalStartDay
        self.rentalEndDay = rentalEndDay
        self.rentalTime = rentalTime
        self.map = map
    }
}

public enum RentalStateType: Int, Equatable, Codable{
    case rentalAvailable
    case rentalNotPossible
    case renting
    
    public var description: String {
        switch self {
        case .rentalAvailable:
            return "대여 가능"
        case .rentalNotPossible:
            return "대여 불가능"
        case .renting:
            return "대여 중"
        }
    }
}

