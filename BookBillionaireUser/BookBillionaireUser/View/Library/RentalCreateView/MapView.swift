//
//  MapView.swift
//  temp20_shareSelectedLocation
//
//  Created by Seungjae Yu on 4/17/24.
//

import SwiftUI
import MapKit
struct MapView: UIViewRepresentable {
    
    let coordinate: CLLocationCoordinate2D
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @Binding var annotations: [MKPointAnnotation]
    @State var address: String = ""
    @State var address2: String = ""
    let addressUpdated: (String, String, Double, Double) -> Void // 클로저 변경

    func makeUIView(context: Context) -> MKMapView {
        locationManager.requestWhenInUseAuthorization()

        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.frame = UIScreen.main.bounds

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        addMarkerAtCoordinate(coordinate, mapView: mapView)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No update needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func addMarkerAtCoordinate(_ coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.annotations = [annotation]
        mapView.addAnnotation(annotation)
    }

    class Coordinator: NSObject {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard gesture.state == .ended else { return }

            let mapView = gesture.view as! MKMapView
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            print("터치 좌표: \(coordinate.latitude), \(coordinate.longitude)")

            mapView.removeAnnotations(mapView.annotations)

            addTouchMarkerAtCoordinate(coordinate, mapView: mapView)

            parent.geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    print("주소 정보를 찾을 수 없습니다.")
                    return
                }
                
                let address = "\(placemark.country ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? "")"
                let address2 = "\(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? "")"
                print("주소: \(address)")
                print("주소2: \(address2)")
                self.parent.address = address
                self.parent.address2 = address2
                // 좌표 정보와 함께 주소 업데이트 클로저 호출
                self.parent.addressUpdated(address, address2, coordinate.latitude, coordinate.longitude)
            }
        }
        
        func addTouchMarkerAtCoordinate(_ coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.parent.annotations = [annotation]
            mapView.addAnnotation(annotation)
        }
    }
}

