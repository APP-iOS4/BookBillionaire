//
//  SettingButtonView.swift
//  Practice00
//
//  Created by 홍승표 on 3/9/24.
//

import SwiftUI
import BookBillionaireCore

struct SettingButton: View {
    @EnvironmentObject var htmlLoadService: HtmlLoadService
    @State private var isGoToNotice: Bool = false
    @State private var isGoToQandA: Bool = false
    @State private var isGoToPolicy: Bool = false
    @State private var isGoToTerms: Bool = false
    @Binding var shouldLogout: Bool
    var buttonType: SettingMenuType
    
    @State private var policyUrl: URL? = nil
    @State private var termsUrl: URL? = nil

    var body: some View {
        VStack {
            HStack {
                Button {
                    handleButtonTap()
                } label: {
                    Text("\(buttonType.rawValue)")
                        .font(.body)
                }
                .tint(.primary)
            }
            .padding(.vertical, 10)
        }
        .navigationDestination(isPresented: $isGoToNotice) {
            NoticeView(menuType: .notice)
        }
        .navigationDestination(isPresented: $isGoToQandA) {
            QAView()
        }
        .navigationDestination(isPresented: $isGoToPolicy) {
            if let url = policyUrl {
                    WebView(url: url)
                } else {
               
                    Text("Loading...")
                }
        }
        .navigationDestination(isPresented: $isGoToTerms) {
            if let url = termsUrl {
                    WebView(url: url)
                } else {
                    Text("Loading...")
                }
        }
    }
    
    private func handleButtonTap() {
        switch buttonType {
        case .notice:
            isGoToNotice = true
        case .qanda:
            isGoToQandA = true
        case .policy:
            Task {
                let htmlFiles = htmlLoadService.privatePolicy
                if let privateFile = htmlFiles.first {
                    policyUrl = privateFile.url
                    isGoToPolicy = true
                }
            }
        case .termsOfouse:
            Task {
                let htmlFiles = htmlLoadService.termsOfUse
                if let termsFile = htmlFiles.first {
                    termsUrl = termsFile.url
                    isGoToTerms = true
                }
            }

        case .logOut:
            shouldLogout = true
        }
    }
}

#Preview {
    SettingButton(shouldLogout: .constant(false), buttonType: .notice)
}
