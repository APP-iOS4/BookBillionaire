//
//  BookSearchView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/3/24.
//

import SwiftUI
import WebKit

struct BookSearchView: View {
    @State private var searchBook = ""
    @State private var recentSearches: [String] = []
    @State private var isWebViewPresented = false
    @State private var selectedBookstoreURL: BookStoreUrl?
    
    var body: some View {
        VStack(alignment: .center) {
            SearchBar(searchBook: $searchBook)
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text("찾는 책이 없다면? 찾아보러가기")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(alignment: .center) {
                    // 교보문고
                    ForEach(BookStoreUrl.allCases, id: \.self) { bookstore in
                        Button {
                            selectedBookstoreURL = bookstore
                            isWebViewPresented.toggle()
                        } label: {
                            Image(systemName: "square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                    }
                    .sheet(isPresented: $isWebViewPresented) {
                        
                    }
                }
            }
        }
        .padding()
    }
}
// url 링크
enum BookStoreUrl: String, CaseIterable {
    case kyobo = "교보문고"
    case yes24 = "Yes24"
    case aladdin = "알라딘"
    case books = "북스"
    
    var url: URL {
        switch self {
        case .kyobo:
            return URL(string: "https://www.kyobobook.co.kr")!
        case .yes24:
            return URL(string: "https://www.yes24.com")!
        case .aladdin:
            return URL(string: "https://www.aladin.co.kr")!
        case .books:
            return URL(string: "https://www.kyobobook.co.kr")! // 예시로 교보문고 URL 사용! 여기 무슨 사이트 입니까? 리딩북스?
        }
    }
}


// 웹뷰
struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}


#Preview {
    BookSearchView()
}
