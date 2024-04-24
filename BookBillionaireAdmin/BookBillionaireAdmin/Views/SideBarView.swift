//
//  SideBarView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/22/24.
//

import SwiftUI

struct SideBarView: View {
    var sideBarService = SideBarService()
    
    var body: some View {
        List {
            ForEach(sideBarService.sideBarGroup) { sideBar in
                Section("\(sideBar.category)") {
                    ForEach(sideBar.topics) { topic in
                        NavigationLink {
                            NavigationStack {
                                switch topic.topicTitle {
                                case .userManage:
                                    UserManageView(topic: topic)
                                case .book:
                                    BookListView(topic: topic)
                                case .user:
                                    UserListView(topic: topic)
                                case .bookManage:
                                    BookManageView(topic: topic)
                                case .complain:
                                    ComplainView(topic: topic)
                                }
                            }
                        } label: {
                            HStack {
                                Label(topic.name, systemImage: topic.Icon)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Boards")
    }
}

#Preview
{
    SideBarView()
}
