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
    public var rentalStartDay: Date
    public var rentalEndDay: Date
    public var rentalTime: Date?
    public var map: String?
    
    public init(id: String, bookOwner: String, bookBorrower: String? = nil, rentalStartDay: Date, rentalEndDay: Date, rentalTime: Date? = nil, map: String? = nil) {
        self.id = id
        self.bookOwner = bookOwner
        self.bookBorrower = bookBorrower
        self.rentalStartDay = rentalStartDay
        self.rentalEndDay = rentalEndDay
        self.rentalTime = rentalTime
        self.map = map
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: RentalCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.bookOwner = try container.decode(String.self, forKey: .bookOwner)
        self.bookBorrower = try container.decodeIfPresent(String.self, forKey: .bookBorrower)
        self.rentalStartDay = try container.decode(Date.self, forKey: .rentalStartDay)
        self.rentalEndDay = try container.decode(Date.self, forKey: .rentalEndDay)
        self.rentalTime = try container.decodeIfPresent(Date.self, forKey: .rentalTime)
        self.map = try container.decodeIfPresent(String.self, forKey: .map)
    }
}

public enum RentalCodingKeys: String, CodingKey {
    case id, bookOwner
    case bookBorrower
    case rentalStartDay
    case rentalEndDay
    case rentalTime
    case map
}
