//
//  bannerview.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/24/24.
//


import SwiftUI

struct bannerview: View {
    @State private var currentIndex = 0
    var banners = ["banner1", "banner2", "banner3"]

    // 첫 번째 배너를 배열의 마지막에 추가하고, 마지막 배너를 배열의 처음에 추가
    var infiniteBanners: [String] {
        var banners = self.banners
        banners.insert(banners.last!, at: 0)
        banners.append(banners[1])
        return banners
    }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(infiniteBanners.indices, id: \.self) { index in
                Image(infiniteBanners[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .tag(index)
                    .onAppear {
                        if index == 0 {
                            currentIndex = 1
                        }
                    }
            }
        }
        .frame(height: 200)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .gesture(
            DragGesture().onEnded { value in
                if value.predictedEndTranslation.width > 50 {
                    currentIndex = (currentIndex - 1 + infiniteBanners.count) % infiniteBanners.count
                    if currentIndex == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            currentIndex = infiniteBanners.count - 2
                        }
                    }
                } else if value.predictedEndTranslation.width < -50 {
                    currentIndex = (currentIndex + 1) % infiniteBanners.count
                    if currentIndex == infiniteBanners.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            currentIndex = 1
                        }
                    }
                }
            }
        )
        .onChange(of: currentIndex) { newValue in
            if newValue == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentIndex = infiniteBanners.count - 2
                }
            } else if newValue == infiniteBanners.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentIndex = 1
                }
            }
        }
    }
}


#Preview {
    bannerview()
}
