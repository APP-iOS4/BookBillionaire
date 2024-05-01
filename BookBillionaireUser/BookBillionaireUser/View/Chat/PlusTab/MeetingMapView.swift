//
//  MeetingMapView.swift
//  BookBillionaireUser
//
//  Created by 최준영 on 4/29/24.
//

import BookBillionaireCore
import FirebaseFirestore
import MapKit
import SwiftUI

struct MeetingMapView: View {
    let book: Book
    let roomVM: ChatListViewModel
    // @State var rentals: Rental = Rental()
    // @EnvironmentObject var rentalService: RentalService
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5710764, longitude: 126.9788955), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    @State private var annotations = [AnnotationItem]()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: [.zoom], annotationItems: annotations) { annotation in
                MapPin(coordinate: annotation.coordinate, tint: .red)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button("확인") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(AccentButtonStyle())
                    .padding()
                }
            }
        }
        .navigationBarTitle("약속 장소")
        .onAppear {
            roomVM.fetchLatLongForBookId(book.id) { lat, long in
                guard let latitude = lat, let longitude = long else {
                    return
                }
                
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                
                let annotation = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                annotations.append(annotation)
            }
            
            // print("rentals.id========\(rentals.id)") // 이건 쓰면 안될듯
            print("book.id\(book.id), \(book.title)")
            // book.id를 가진 rentals 의 항목을 찾아서 그 항목의 위치값을 뽑아 낸다?
        }
    }
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
