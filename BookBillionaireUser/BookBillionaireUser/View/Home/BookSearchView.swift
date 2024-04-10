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
    @State private var selectedBookstoreSettings: BookStoreSettings?
    
    var body: some View {
        VStack(alignment: .center) {
            SearchBar(searchBook: $searchBook)
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text("찾는 책이 없다면? 찾아보러가기")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                HStack(alignment: .center) {
                    // 사이트 링크 & 아이콘
                    ForEach(BookStoreSettings.allCases, id: \.self) { bookstore in
                        Button {
                            selectedBookstoreSettings = bookstore
                            isWebViewPresented.toggle()
                    
                        } label: {
                          bookstore.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                    }
                    .sheet(isPresented: $isWebViewPresented) {
                        if let selectedURL = selectedBookstoreSettings?.url {
                            WebView(url: selectedURL)
                        }
                    }
                    
                }
            }
        }
        .padding()
    }
}

// url 링크
enum BookStoreSettings: String, CaseIterable {
    case kyobo = "교보문고"
    case yes24 = "Yes24"
    case aladin = "알라딘"
    case books = "북스"
    
    var url: URL {
        switch self {
        case .kyobo:
            return URL(string: "https://www.kyobobook.co.kr")!
        case .yes24:
            return URL(string: "https://www.yes24.com")!
        case .aladin:
            return URL(string: "https://www.aladin.co.kr")!
        case .books:
            return URL(string: "https://www.naver.com")!
        }
    }
    // 아이콘
    var image: Image {
        switch self {
        case .kyobo:
            return Image("kyobo")
        case .yes24:
            return Image("yes24")
        case .aladin:
            return Image("aladin")
        case .books:
            return Image("books")
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
