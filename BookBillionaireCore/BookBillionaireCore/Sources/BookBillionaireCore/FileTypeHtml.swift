//
//  FileTypeHtml.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/28/24.
//

import Foundation

public struct FileTypeHtml: Identifiable, Codable {
    public var id: String
    public var type: FileType
    public var url: URL?
    public var createAt: Date
    
    public init(type: FileType) {
        self.id = UUID().uuidString
        self.type = type
        self.createAt = Date()
    }
}

public enum FileType: String, Codable {
    case privatePolicy = "privatePolicy"
    case termsOfUse = "Terms Of Use"
    
    
}
