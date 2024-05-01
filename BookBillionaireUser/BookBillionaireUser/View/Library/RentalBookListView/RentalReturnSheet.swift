//
//  RentalReturnSheet.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 5/1/24.
//

import SwiftUI
import BookBillionaireCore

struct RentalReturnSheet: View {
    var rental: Rental
    @State private var returnDate: Date = Date()
    @State private var returnMethod: Int = 1
    @State private var isDamaged: Bool = false
    @State private var hasIssues: Bool = false
//    @State private var isShowingAlert: Bool = false
//    @State private var isShowingReviewView: Bool = false
    @Binding var isShowingReturnSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("대여 반납일", selection: $returnDate, in: rental.rentalStartDay..., displayedComponents: [.date])
                HStack {
                    Text("반납 방법")
                    Spacer()
                    Picker("반납 방법", selection: $returnMethod) {
                        Text("만나서").tag(1)
                        Text("택배").tag(2)
                        Text("무인반납").tag(3)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.15))
                    .onChange(of: returnMethod) { newValue in
                        print("반납 방법이 \(newValue)로 변경되었습니다.")
                    }
                    .pickerStyle(.menu)
                }
                Toggle(isOn: $isDamaged) {
                    VStack(alignment: .leading) {
                        Text("파손 여부")
                        Text("책이 파손되었나요?")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }
                }
                Toggle(isOn: $hasIssues) {
                    VStack(alignment: .leading) {
                        Text("이상 여부")
                        Text("책에 이상이 있나요?")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 20)
                Button("완료") {
                    // 대여 반납 정보를 저장하는 코드
                    isShowingReturnSheet.toggle()
//                    isShowingAlert = true
                }
                .buttonStyle(AccentButtonStyle(height: 50))
//                .alert("", isPresented: $isShowingAlert) {
//                    Button(role: .cancel) {
//                        isShowingReturnSheet.toggle()
//                    } label: {
//                        Text("취소")
//                    }
//
//                    Button("리뷰 쓰기") {
//                        isShowingReviewView = true
//                    }
//                } message: {
//                    Text("""
//                        반납 정보가 성공적으로 저장되었습니다.
//                        리뷰를 작성하시겠습니까?
//                        """)
//                }
//                .navigationDestination(isPresented: $isShowingReviewView) {
//                    Text("리뷰 작성뷰")
//                }
            }
            .padding()
            .navigationTitle("대여 반납")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isShowingReturnSheet.toggle()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RentalReturnSheet(rental: Rental(), isShowingReturnSheet: .constant(false))
    }
}
