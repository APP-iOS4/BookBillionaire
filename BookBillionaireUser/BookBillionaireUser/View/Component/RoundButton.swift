//
//  RoundButton.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/7/24.
//

import SwiftUI

struct RoundButton: View {
    var text: String
    var buttonAction: () -> ()
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            HStack {
                Text(text)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding()
        }
    }
}
