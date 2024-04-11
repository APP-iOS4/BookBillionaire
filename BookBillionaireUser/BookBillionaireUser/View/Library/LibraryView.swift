//
//  LibraryView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        switch authViewModel.state {
        case .loggedIn:
            VStack {
                Section(header: CategoryView(selectedIndex: $selectedIndex)) {
                    if selectedIndex == 0 {
                        MyBookListView()
                    } else {
                        RentalBookListView()
                    }
                    Spacer()
                }
            }
            .toolbarBackground(.background, for: .navigationBar)
            .navigationTitle("내 서재")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        BookCreateView()
                    } label: {
                        if selectedIndex == 0 {
                            Label("plus", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
            }
        case .loggedOut:
            UnlogginedView()
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView()
            .environmentObject(AuthViewModel())
    }
}
