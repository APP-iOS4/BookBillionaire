//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

/// 도서정보에 대한 구조체
public struct Book: Identifiable, Codable {
    public var id: String
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
    
    public init(id: String = UUID().uuidString, owenerID: String, isbn: String? = nil, title: String, contents: String, publisher: String? = nil, authors: [String], translators: [String]? = nil, price: Int? = nil, thumbnail: String, bookCategory: BookCategory? = nil, rental: String) {
        
        self.id = id
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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.ownerID = try container.decode(String.self, forKey: .ownerID)
        self.isbn = try container.decodeIfPresent(String.self, forKey: .isbn)
        self.title = try container.decode(String.self, forKey: .title)
        self.contents = try container.decode(String.self, forKey: .contents)
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        self.authors = try container.decode([String].self, forKey: .authors)
        self.translators = try container.decodeIfPresent([String].self, forKey: .translators)
        self.price = try container.decodeIfPresent(Int.self, forKey: .price)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.bookCategory = try container.decodeIfPresent(BookCategory.self, forKey: .bookCategory)
        self.rental = try container.decode(String.self, forKey: .rental)
        
        
    
    }
    
    // 샘플 Book 생성
        public static var sample: Book {
            Book(owenerID: "ownerID", title: "샘플 제목", contents: "샘플 내용", authors: ["샘플 작가"], thumbnail: "샘플 썸네일", rental: "샘플 렌탈")
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
