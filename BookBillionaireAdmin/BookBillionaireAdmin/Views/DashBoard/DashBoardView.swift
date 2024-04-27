//
//  DashboardView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import SwiftUI

struct DashBoardView: View {
    @EnvironmentObject var userService: UserService
    var body: some View {
        VStack{
            CountBoxView(title: "현재 유저 수", count: userService.users.count)
            
        }
       
    }
}

#Preview {
    DashBoardView()
        .environmentObject(UserService())
}
