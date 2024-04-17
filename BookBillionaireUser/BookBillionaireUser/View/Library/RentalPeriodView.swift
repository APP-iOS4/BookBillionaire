//
//  RentalPeriodView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore
import MapKit

struct RentalPeriodView: View {
    @Binding var rental: Rental
    @State private var annotations = [MKPointAnnotation]()
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("대여 정보 설정")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .fontWeight(.medium)
            DatePicker("대여 시작일", selection: $rental.rentalStartDay, in: Date()..., displayedComponents: [.date])
            DatePicker("대여 종료일", selection: $rental.rentalEndDay, in: rental.rentalStartDay..., displayedComponents: [.date])
            
            HStack {
                Text("대여 희망지역")
                Spacer()
                Button {
                    isShowingSheet.toggle()
                } label: {
                    Text("\(rental.map)")
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary))
            }
        }
        .padding()
        .sheet(isPresented: $isShowingSheet)  {
            MapView(coordinate: CLLocationCoordinate2D(latitude: 37.42693258406499, longitude: -122.23547899839053), annotations: $annotations, address: rental.map)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    RentalPeriodView(rental:.constant(Rental(id: "", bookOwner: "",rentalStartDay: Date(), rentalEndDay: Date(), map: "", latitude: 0.0, longitude: 0.0)))
}
