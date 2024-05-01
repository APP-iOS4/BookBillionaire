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
    var user: String
    let room: RoomViewModel
    let roomVM: ChatListViewModel
    @State var book: Book
    @EnvironmentObject var userService : UserService
    @State private var showAlert = false

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
                }
                .navigationBarTitle("\(roomName(users: room.room.users))님과의 약속")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.inset)
            }
            
            Spacer()
            
            Button("약속 잡기") {
                roomVM.createPromise(booktitle: book.title, bookId: book.id, ownerId: room.users[0], senderId: room.users[1], makeDate: Date(), selectedTime: selectedTime, selectedDate: selectedDate)
                presentationMode.wrappedValue.dismiss()
                showAlert = true
            }
            .buttonStyle(AccentButtonStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 15)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("약속이 확정되었습니다."), dismissButton: .default(Text("확인")))
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
    
    private func updateRentalTime() {
        Task{
            await rentalService.updateRentalTime(book.rental, rentalTime: combine(date: selectedDate, withTime: selectedTime) ?? Date())
            book.rentalState = .renting
        }
    }
    private func roomName(users: [String]) -> String {
        for user in users {
            if user != userService.currentUser.id {
                return userService.loadUserByID(user).nickName
            }
        }
        return "사용자 이름없음"
    }
}



//#Preview {
//    PromiseConfirmView(user: User(id: "", nickName: "", address: ""), book: Book(owenerID: "", title: "", contents: "", authors: [], rentalState: RentalStateType.rentalNotPossible))
//}
