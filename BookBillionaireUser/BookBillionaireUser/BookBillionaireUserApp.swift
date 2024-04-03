//
//  BookBillionaireUserApp.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

@main
struct BookBillionaireUserApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryView(selectedIndex: .constant(0))
        }
    }
}
