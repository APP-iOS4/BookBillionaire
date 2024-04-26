//
//  SearchBook.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/26/24.
//

import Foundation

struct SearchBook: Identifiable, Codable {
    var id: String {title}
    let isbn: String
    let title: String
    let contents: String
    let publisher: String
    let authors: [String]
    let translators: [String]
    let price: Int
    let thumbnail: String
}

struct apiSearchResponse: Decodable {
    let documents: [SearchBook]
}
