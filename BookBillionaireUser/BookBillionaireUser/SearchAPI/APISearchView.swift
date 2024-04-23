//
//  APISearchBar.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 3/25/24.
//

import SwiftUI
import BookBillionaireCore

struct SearchBook: Identifiable, Codable {
    var id: String {title}
    let isbn: String
    let title: String
    let contents: String
    let publisher: String
    let authors: [String]
    let translators: [String]
    let price: Int
    let thumbnail: String
}

struct apiSearchResponse: Decodable {
    let documents: [SearchBook]
}

struct APISearchView: View {
    @Binding var searchBook: String?
    @State private var books: [SearchBook] = []
    @State private var isLoading = false
    @State private var apiKey = ""
    @Binding var isShowing: Bool
    
    private func fetchMyKey() {
        if let plistPath = Bundle.main.path(forResource: "key", ofType: "plist"),
           let plistData = FileManager.default.contents(atPath: plistPath),
           let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
           let myKey = plistDictionary["myKey"] as? String {
            apiKey = myKey
        } else {
            print("APIKey오류")
        }
    }
    
    func encodeQuery(_ query: String) -> String {
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.replacingOccurrences(of: "+", with: "%20")
    }
    
    var body: some View {
        VStack {
            APISearchBar(searchBook: $searchBook, onSearch: {
                guard let query = searchBook else { return }
                isLoading = true
                let queryEncoded = encodeQuery(query)
                let url = URL(string: "https://dapi.kakao.com/v3/search/book?query=\(queryEncoded)")!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue(apiKey, forHTTPHeaderField: "Authorization")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        isLoading = false
                        if let error = error {
                            print("오류 발생:", error)
                            return
                        }
                        
                        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                            print("잘못된 응답:", response!)
                            return
                        }
                        
                        guard let data = data else {
                            print("데이터 없음")
                            return
                        }
                        
                        let decoder = JSONDecoder()
                        if let searchResponse = try? decoder.decode(apiSearchResponse.self, from: data) {
                            self.books = searchResponse.documents
                        }
                    }
                }.resume()
            })
            
            if isLoading {
                ProgressView()
            } else if books.count != 0 {
                List(books, id: \.id) { book in
                    NavigationLink {
                        BookCreateView(searchBook: book)
                    } label: {
                        APISearchListRowView(book: book)
                    }
                }
                .listStyle(.plain)
            } else {
                Text("검색 결과가 없습니다.")
            }
            Spacer()
        }
        .onAppear {
            fetchMyKey()
        }
        .navigationTitle("책 검색")
        .navigationBarTitleDisplayMode(.inline)
    }
}
