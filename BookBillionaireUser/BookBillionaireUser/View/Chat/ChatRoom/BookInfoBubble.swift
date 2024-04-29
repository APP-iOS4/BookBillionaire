//
//  BookInfoBubble.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/26/24.
//

import SwiftUI

struct BookInfoBubble: View {
    
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string:
                                    "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1103577%3Ftimestamp%3D20221025123259"
                               )) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 90)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .padding(.leading, 20)
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Clean Code(클린 코드)")
                    .lineLimit(1)
                    .bold()
                Spacer()
                
                Text("『Clean Code(클린 코드)』은 오브젝트 멘토(Object Mentor)의 동료들과 힘을 모아 ‘개발하며’ 클린 코드를 만드는 최상의 애자일 기법을 소개하고 있다. 소프트웨어 장인 정신의 가치를 심어 주며 프로그래밍 실력을 높여줄 것이다. 여러분이 노력만 한다면. 어떤 노력이 필요하냐고? 코드를 읽어야 한다. 아주 많은 코드를. 그리고 코드를 읽으면서 그 코드의 무엇이 옳은지, 그른지 생각도 해야 한다. 좀 더 중요하게는 전문가로서 자신이 지니는 가치")
                    .lineLimit(2)
                    .font(.subheadline)
                
                Spacer()
            }
            .padding(.trailing, 25)
            
            Spacer()
        }
        .frame(maxWidth: 350, maxHeight: 130)
        .lineLimit(3)
        .background(Color.gray .opacity(0.9))
        .cornerRadius(15)
        .foregroundColor(.white)
    }
}

#Preview {
    BookInfoBubble()
}
