//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

/// 도서정보에 대한 구조체
public struct Book: Identifiable, Codable {
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
    
    public init(owenerID: String, isbn: String? = nil, title: String, contents: String, publisher: String? = nil, authors: [String], translators: [String]? = nil, price: Int? = nil, thumbnail: String, bookCategory: BookCategory? = nil, rental: String) {
        
        self.ownerID = owenerID
        self.isbn = isbn
        self.title = title
        self.contents = contents
        self.publisher = publisher
        self.authors = authors
        self.translators = translators
        self.price = price
        self.thumbnail = thumbnail
        self.bookCategory = bookCategory
        self.rental = rental
    }
    
    
}

public enum BookCategory: String, CaseIterable, Identifiable, Codable {
    
    public var id: String {
        self.rawValue
    }
    case hometown = "우리 동네에서 빌려요~ 🏡"
    case suggestion = "빌리네어가 추천해요! 🤩"
    case soaring = "요즘 사람들이 많이 찾고 있어요 👀"
    case best = "베스트🥇"
    
    public var buttonTitle: String {
        switch self {
        case .hometown:
            return "집근처"
        case .suggestion:
            return "추천"
        case .soaring:
            return "인기 급상승 🚀"
        case .best:
            return "베스트 🥇"
        }
    }
}
