//
//  QnAView.swift
//  BookBillionaireAdmin
//
//  Created by YUJIN JEON on 4/16/24.
//

import SwiftUI

struct QnAView: View {
    var body: some View {
        VStack{
            HStack(spacing: 50){
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.bbBGcolor)
                    VStack{
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color.bbBGcolor)
                }
            }
            .padding(50)
        }
    }
}

#Preview {
    QnAView()
}
