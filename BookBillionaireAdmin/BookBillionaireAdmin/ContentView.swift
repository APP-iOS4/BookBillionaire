////
////  ContentView.swift
////  BookBillionaireAdmin
////
////  Created by Woo Sung jong on 4/3/24.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State var selectedCategory:
//    
//    var body: some View {
//        NavigationSplitView {
//            VStack(alignment: .leading, spacing: 30) {
//                Image("logoShortCut")
//                    .resizable()
//                    .frame(width: 200, height: 200, alignment: .leading)
//                    .scaledToFit()
//                }
//                Spacer()
//                Button("로그아웃") {
//                    //
//                }
//            }
//            .padding()
//            
//        } detail: {
//            switch $selectedCategory.name {
//            case "board":
//                AnyView(DashBoardView())
//            case "qna":
//                AnyView(QnAView())
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView(selectedCategory: CategoryStore().categories[1])
//}
