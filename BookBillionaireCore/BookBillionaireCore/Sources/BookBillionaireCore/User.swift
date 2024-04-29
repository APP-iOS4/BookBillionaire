//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct User: Identifiable, Codable {
    public var id: String
    public var nickName: String
    public var email: String
    public var address: String
    public var image: String?
    public var point: Int?
    public var favorite: [String]?
    public var myBooks: [String]? //북정보를 가지고 있음
    public var rentalBooks: [String]? //렌탈정보를 가지고 있음
    public var createAt: Date = Date()

    public init() {
        self.id = UUID().uuidString
        self.nickName = ""
        self.address = ""
        self.image = ""
        self.email = ""
    }
    
    public init(nickName: String, address: String, image: String? = nil, point: Int? = 0, rentalBooks: [String]? = [], email: String) {
        self.id = UUID().uuidString
        self.nickName = nickName
        self.address = address
        self.image = image
        self.point = point
        self.email = email
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nickName = try container.decode(String.self, forKey: .nickName)
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? "주소 정보 없음"
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.myBooks = try container.decodeIfPresent([String].self, forKey: .myBooks) ?? [""]
        self.rentalBooks = try container.decodeIfPresent([String].self, forKey: .rentalBooks) ?? [""]
        self.email = try container.decode(String.self, forKey: .email)
    }
}

public enum UserCodingKeys: String, CodingKey {
    case id, address
    case nickName = "nickname"
    case image = "profileImage"
    case price
    case pointUserID
    case myBooks
    case rentalBooks
    case email = "emailEqualtoAuth"
}
