//
//  LibraryView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: CategoryView(selectedIndex: $selectedIndex)) {
                    if selectedIndex == 0 {
                        MyBookListView()
                    } else {
                        RentalBookListView()
                    }
                }
                Spacer()
            }
        }
        .navigationTitle("내 서재")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.background, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    Text("책 등록 뷰")
                } label: {
                    if selectedIndex == 0 {
                        Label("plus", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
