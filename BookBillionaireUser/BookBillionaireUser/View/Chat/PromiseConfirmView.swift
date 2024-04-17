//
//  PromiseConfirmView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/3/24.
//

import SwiftUI
import BookBillionaireCore

struct PromiseConfirmView: View {
    @State private var dateViewShowing = false
    @State private var timeViewShowing = false
    @State private var mapViewShowing = false
    @State var selectedTime = Date()
    @State var selectedDate = Date()
    @Environment (\.dismiss) private var dismiss
    @State var rentalService: RentalService = RentalService()
    var user: User
    @State var book: Book

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("\(book.title)에 대한 약속잡기")
                    .font(.title2)
                    .padding()
                    .padding(.bottom, 20)
                List {
                    HStack {
                        Text("날짜")
                        Spacer()
                        Button {
                            // 달력 뷰 토글하기
                            dateViewShowing.toggle()
                        } label: {
                            HStack {
                                Text("\(dateFormatter.string(from:selectedDate))")
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .sheet(isPresented: $dateViewShowing, content: {
                            DatePickerView(selectedDate: $selectedDate)
                                .presentationDetents([.medium])
                        })
                    }
                    
                    HStack {
                        Text("시간")
                        Spacer()
                        Button {
                            // 시간 뷰 토글하기
                            timeViewShowing.toggle()
                        } label: {
                            HStack {
                                Text("\(timeFormatter.string(from: selectedTime))")
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .sheet(isPresented: $timeViewShowing, content: {
                            TimePickerView(selectedTime: $selectedTime)
                                .presentationDetents([.height(300)])
                        })
                    }
                    //결제방식 일단 아웃
                    //                    HStack {
                    //                        Text("결제 방식")
                    //
                    //                        Spacer()
                    //
                    //                        Button {
                    //                            // 결제 방식 고르기 창 조금 보여주기
                    //                            // .sheet로 보여주면 될 듯
                    //                        } label: {
                    //                            HStack {
                    //                                Text("결제 방식 선택")
                    //                                    .foregroundStyle(.gray)
                    //                                Image(systemName: "chevron.down")
                    //                                    .foregroundStyle(.gray)
                    //                            }
                    //                        }
                    //                    }
                    

                    //                    HStack {
                    //                        Text("장소")
                    //
                    //                        Spacer()
                    //
                    //                        Button {
                    //                            // 맵 뷰 토글하기
                    //                            mapViewShowing.toggle()
                    //                        } label: {
                    //                            NavigationLink(destination: MeetingMapView()) {
                    //                                HStack {
                    //                                    Spacer()
                    //                                    Text("장소 선택")
                    //                                        .foregroundStyle(.gray)
                    //                                }
                    //                            }
                    //                        }
                    //                    }

//                    HStack {
//                        Text("장소")
//                        
//                        Spacer()
//                        
//                        Button {
//                            // 맵 뷰 토글하기
//                            mapViewShowing.toggle()
//                        } label: {
//                            NavigationLink(destination: MeetingMapView()) {
//                                HStack {
//                                    Spacer()
//                                    Text("장소 선택")
//                                        .foregroundStyle(.gray)
//                                }
//                            }
//                        }
//                    }

                }
                .navigationBarTitle("\(user.nickName)님과의 약속")
                .navigationBarTitleDisplayMode(.inline)
                //  .toolbarTitleDisplayMode(.inline) //17버전에서 사용가능
                .listStyle(.inset)
            }
            
            Spacer()
            
            Button("약속 잡기") {
                updateRental()
                presentationMode.wrappedValue.dismiss()
                
            }
            .buttonStyle(AccentButtonStyle())
            .padding(.horizontal, 30)
        }
        
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func combine(date: Date, withTime time: Date) -> Date? {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents)
    }
    
    private func updateRental() {
        Task{
            await rentalService.updateRental(book.rental, rentalTime: combine(date: selectedDate, withTime: selectedTime) ?? Date())
            book.rentalState = .renting
        }
    }
}



//#Preview {
//    PromiseConfirmView()
//}
