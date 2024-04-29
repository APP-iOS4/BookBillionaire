//
//  NoticeItem.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/26/24.
//

import SwiftUI

struct NoticeItem: View {
    var notice: NoticeDummy
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(notice.title)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    Text("\(notice.dateString)")
                        .font(.subheadline)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                
                Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            }
            .padding()
            .onTapGesture {
                withAnimation(.easeOut) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Text("\(notice.content)")
                    .padding()
            }
        }
    }
}

#Preview {
    NoticeItem(notice: dummyNotice.first!)
}
