//
//  SideBarGroup.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/22/24.
//

import Foundation

public struct SideBarGroup: Identifiable {
    public var id: UUID = UUID()
    public var category: String
    public var topics: [Topic]
}
