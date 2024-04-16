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
    // 타이머
    private let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    // 재생/일시정지
    @State var isPlaying = true
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(banners.indices, id: \.self) { index in
                    Image(banners[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(.horizontal, 10)
                        .tag(index) // 각 이미지에 인덱스를 태그로 지정
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .overlay(
                // 배너 페이지 수
                Text("\(currentIndex + 1) / \(banners.count)")
                    .font(.caption)
                    .padding(5)
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)),
                alignment: .bottomTrailing
            )
            .overlay(
                // 재생 / 일시정지 버튼
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .foregroundStyle(.black.opacity(0.5))
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 0)),
                alignment: .bottomLeading
            )
            .onTapGesture {
                isPlaying.toggle()
            }
            
        }
        .onReceive(timer) { _ in
            withAnimation() {
                if isPlaying {
                    currentIndex += 1
                    if currentIndex >= banners.count {
                        currentIndex = 0
                    }
                }
            }
        }
    }
}

#Preview {
    HomePagingView()
}
