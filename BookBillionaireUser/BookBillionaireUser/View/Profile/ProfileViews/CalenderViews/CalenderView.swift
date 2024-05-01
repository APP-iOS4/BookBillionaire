//
//  CalenderView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 5/1/24.
//

import SwiftUI

struct CalenderView: View {
    @Environment(\.colorScheme) var colorScheme
    var customCalenderBackgroundColor: Color {
        colorScheme == .dark ? Color("BGColor") : Color.white
    }
    @State private var currentDate: Date = Date()
    // 월수 변환 버튼
    @State private var currentMonth: Int = 0
    let days: [String] = ["Sun", "Mon", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(alignment: .center, spacing: 20) {
                Button {
                    currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.accent)
                
                }
                Spacer()
                // 년도, 월
                VStack(alignment: .center, spacing: 5) {
                    Text(extraDate()[1])
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(extraDate()[0])
                        .font(.title.bold())
            
                }
                Spacer()
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.accent)
                }
            }
            .padding()
            .foregroundStyle(.primary)
          
            // 요일
            HStack(spacing: 0) {
                ForEach(days, id: \.self) {
                    day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(extractDate()) { value in
                    CardView(value: value)
                }
                .padding(.vertical, 10)
            }
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
        .padding()
        .background(customCalenderBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                // 주말 표기
                let calendar = Calendar.current
                let weekday = calendar.component(.weekday, from: value.date)
                
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundStyle(weekday == 0 || weekday == 1 ? .red : .primary)
            }
        }
    }
    
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from:  days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

#Preview {
    CalenderView()
}
// 특정 날짜가 속한 월의 모든 날짜를 배열로 반환하는 역할
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        var range = calendar.range(of: .day, in: .month, for: self)
        range?.removeLast()
        
        // range가 nil인 경우 빈 배열을 반환
        return range?.compactMap { day -> Date in
            if let date = calendar.date(byAdding: .day, value: day - 1, to: self) {
                return date
            } else {
                return Date()
            }
        } ?? []
    }
}
