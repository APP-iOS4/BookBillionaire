//
//  RLoginInfoView.swift
//  BookBillionaireUser
//
//  Created by YUJIN JEON on 4/13/24.
//

import SwiftUI


struct RLoginInfoView: View {
    @State var banners: [String] = ["sampleImage1", "sampleImage2", "sampleImage3"]
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(banners.indices, id: \.self) { index in
                Image(banners[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .onReceive(timer) { _ in
            withAnimation() {
                    currentIndex += 1
                    if currentIndex >= banners.count {
                        currentIndex = 0
                    }
            }
        }
    }
      
}

#Preview {
    RLoginInfoView()
}
