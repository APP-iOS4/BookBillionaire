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
    @State private var isSearching = false
    @State private var recentSearches: [String] = []
    @State private var isWebViewPresented = false
    @State private var selectedBookstoreURL: BookStoreUrl?
    
    var body: some View {
        // 추후 서치바 컴포넌트로 교체 할게요
        HStack {
            TextField("책 이름을 입력해주세요.", text: $searchBook)
                .keyboardType(.webSearch)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("AccentColor"),lineWidth: 1)
                }
            
            if !searchBook.isEmpty {
                Button(action: {
                    searchBook = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            // 검색 버튼
            Button {
                saveSearchHistory()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.primary)
            }
        }
        // 최근 검색어
        recentSearchView
        
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
    
    // 검색어 저장
    func saveSearchHistory() {
        if !searchBook.isEmpty {
            recentSearches.append(searchBook)
        }
    }
    //검색어 되돌리기
    func removeSearchHistory(search: String) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }
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

extension BookSearchView {
    var recentSearchView: some View {
        VStack {
            // 최근 검색어 표시
            VStack(alignment: .leading) {
                Text("최근 검색어")
                    .font(.headline)
                    .padding(.top)
            }
            
            if recentSearches.isEmpty {
                Text("검색 결과 없음")
                    .foregroundColor(.gray)
                
            } else {
                LazyVStack {
                    ForEach(recentSearches.reversed(), id: \.self) { search in
                        HStack {
                            Text("\(search)")
                                .foregroundColor(.primary)
                            Spacer()
                            
                            Button(action: {
                                removeSearchHistory(search: search)
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.gray)
                            })
                        }
                        Divider()
                    }
                }
                .padding()
            }
        }
    }
}
