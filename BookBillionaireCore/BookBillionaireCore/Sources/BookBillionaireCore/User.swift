//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct User: Identifiable, Codable {
    public var id: String
    public var name: String
    public var email: String
    public var address: String
    public var image: String?
    public var pointUserID: String {id}
    public var myBooks: [String]? //북정보를 가지고 있음
    public var rentalBooks: [String]? //렌탈정보를 가지고 있음

    public init(id: String, name: String, email: String, address: String, image: String? = nil, myBooks: [String]? = nil, rentalBooks: [String]? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.address = address
        self.image = image
        self.myBooks = myBooks
        self.rentalBooks = rentalBooks
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.myBooks = try container.decodeIfPresent([String].self, forKey: .myBooks)
        self.rentalBooks = try container.decodeIfPresent([String].self, forKey: .rentalBooks)
  
    }
    
    //샘플
    public static var sample: User {
        User(id: "", name: "샘플 이름", email: "샘플 메일", address: "샘플 주소")
    }
}
