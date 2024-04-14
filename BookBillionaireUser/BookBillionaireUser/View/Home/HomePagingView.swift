//
//  HomeBannerView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/12/24.
//

import SwiftUI


struct HomePagingView: View {
    @State var banners: [String] = ["banner1", "banner2", "banner3"]
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(banners.indices, id: \.self) { index in
                Image(banners[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .tag(index) // 각 이미지에 인덱스를 태그로 지정
                    .overlay(
                        Text("\(index + 1) / \(banners.count)")
                            .font(.caption)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Capsule())
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10)),
                        alignment: .bottomTrailing
                    )
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex += 1
                if currentIndex >= banners.count {
                    currentIndex = 0
                }
            }
        }
    }
}

#Preview {
    HomePagingView()
}
