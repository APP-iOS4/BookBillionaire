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
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(banners, id: \.self) { banner in
                    Image(banner)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        Spacer()
    }
}

#Preview {
    RLoginInfoView()
}
