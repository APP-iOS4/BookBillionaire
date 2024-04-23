//
//  File.swift
//
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

/// 도서정보에 대한 구조체
public struct Book: Identifiable, Codable, Hashable {
    public var id: String = UUID().uuidString
    public var ownerID: String
    public var isbn: String?
    public var title: String
    public var contents: String
    public var publisher: String?
    public var authors: [String]
    public var translators: [String]?
    public var price: Int?
    public var thumbnail: String
    public var bookCategory: BookCategory?
    public var rental: String //Rental ID
    public var rentalState: RentalStateType
    public var createAt: Date = Date()

    public init() {
        self.ownerID = ""
        self.isbn = ""
        self.title = ""
        self.contents = ""
        self.publisher = ""
        self.authors = [""]
        self.translators = [""]
        self.price = 0
        self.thumbnail = ""
        self.rental = ""
        self.rentalState = .rentalAvailable
    }
    
    /// 일반 초기화
    public init(ownerID: String, isbn: String? = "", title: String, contents: String, publisher: String? = "", authors: [String], translators: [String]? = [""], price: Int? = 0, thumbnail: String = "default", rental: String = "", rentalState: RentalStateType) {
        
        self.ownerID = ownerID
        self.isbn = isbn
        self.title = title
        self.contents = contents
        self.publisher = publisher
        self.authors = authors
        self.translators = translators
        self.price = price
        self.thumbnail = thumbnail
        self.rental = rental
        self.rentalState = rentalState
    }
}

///책 카테고리에 대한 enum
public enum BookCategory: String, CaseIterable, Identifiable, Codable {
    
    public var id: String {
        self.rawValue
    }
    case hometown = "우리 동네에서 빌려요"
    case suggestion = "빌리네어가 추천해요"
    case soaring = "요즘 사람들이 많이 찾고 있어요"
    case best = "베스트"
    
    public var buttonTitle: String {
        switch self {
        case .hometown:
            return "집근처"
        case .suggestion:
            return "추천"
        case .soaring:
            return "인기 급상승"
        case .best:
            return "베스트"
        }
    }
}

/// 렌탈 가능여부에 대한 enum
public enum RentalStateType: String, Equatable, Codable{
    case rentalAvailable = "대여 가능"
    case rentalNotPossible = "대여 불가능"
    case renting = "대여 중"
}

