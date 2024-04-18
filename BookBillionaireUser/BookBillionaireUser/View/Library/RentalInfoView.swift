//
//  RentalPeriodView.swift
//  BookBillionaireUser
//
//  Created by Woo Sung jong on 4/3/24.
//

import SwiftUI
import BookBillionaireCore
import MapKit

struct RentalInfoView: View {
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
                    Text("\(rental.mapDetail)")
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.2))
            }

            if rental.latitude != 0.0 && rental.longitude != 0.0 {
                Text("(\(rental.map) \(rental.mapDetail))")
                    .font(.footnote)
                
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: rental.latitude, longitude: rental.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                    showsUserLocation: false,
                    annotationItems: [rental]) { rental in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: rental.latitude, longitude: rental.longitude), tint: .blue)
                }
                    .frame(height: 200)
                
            } else {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 37.5642135, longitude: 127.0016985),
                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))),
                    showsUserLocation: true)
                
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isShowingSheet, content: {
            MapView(coordinate: CLLocationCoordinate2D(latitude: rental.latitude, longitude: rental.longitude), annotations: $annotations, address: rental.map) { address, address2, latitude, longitude in
                rental.map = address
                rental.mapDetail = address2
                rental.latitude = latitude // rental의 latitude 업데이트
                rental.longitude = longitude // rental의 longitude 업데이트
                // 주소가 업데이트되면 fullScreenCover를 닫음
                isShowingSheet = false
            }
            .edgesIgnoringSafeArea(.all)
        })
    }
}



#Preview {
    RentalInfoView(rental:.constant(Rental(id: "", bookOwner: "",rentalStartDay: Date(), rentalEndDay: Date(), map: "", mapDetail: "", latitude: 0.0, longitude: 0.0)))
}
