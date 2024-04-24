//
//  HomeBannerView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/12/24.
//

import SwiftUI

struct HomeBanner: View {
    @State var banners: [String] = ["banner1", "banner2", "banner3"]
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    @State var isPlaying = true
    
    var extendedBanners: [String] {
        var banners = self.banners
        banners.insert(banners.last!, at: 0)
        banners.append(banners[1])
        return banners
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(extendedBanners.indices, id: \.self) { index in
                    Image(extendedBanners[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal, 10)
                }
            }
            .frame(height: 200)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay (
                // 인디케이터
                HStack {
                    ForEach(0..<banners.count, id: \.self) { index in
                        Circle()
                            .fill(index == (currentIndex) % banners.count ? .white : .gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .padding(.horizontal, 2)
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)),
                alignment: .bottom
                
            )
            .overlay (
                // 배너 페이지 수
                Text("\((currentIndex % banners.count) + 1) / \(banners.count)")
                    .font(.caption)
                    .padding(5)
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20)),
                alignment: .bottomTrailing
            )
            .overlay (
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
                    if currentIndex >= extendedBanners.count - 1 { // 현재 인덱스가 가장 마지막 배너 다음에 위치한 경우
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            currentIndex = 1
                        }
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation() {
                        if value.predictedEndTranslation.width > 50 {
                            currentIndex = (currentIndex - 1 + extendedBanners.count) % banners.count
                        } else if value.predictedEndTranslation.width < -50 {
                            currentIndex = (currentIndex + 1) % (extendedBanners.count)
                        }
                    }
                }
        )
        .onChange(of: currentIndex) { newValue in
            if newValue == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentIndex = extendedBanners.count - 2
                }
            } else if newValue == extendedBanners.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentIndex = 1
                }
            }
        }
    }
}

#Preview {
    HomeBanner()
}
