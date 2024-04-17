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
    
    // 맵뷰에 추가된 핀을 관리하기 위한 배열
    @Binding var annotations: [MKPointAnnotation]
    @State var address: String = ""

    func makeUIView(context: Context) -> MKMapView {
        // 위치 허가 요청
        locationManager.requestWhenInUseAuthorization()

        // 지도 뷰 생성
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.frame = UIScreen.main.bounds

        // 현재 위치 업데이트
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        // 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // 주어진 위치에 마커 추가
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
        self.annotations = [annotation] // 바인딩된 속성을 변경하도록 수정
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

            // 이전에 추가된 핀 모두 제거
            mapView.removeAnnotations(mapView.annotations)

            // 새로운 핀 추가
            addTouchMarkerAtCoordinate(coordinate, mapView: mapView)

            // 좌표에 대한 주소 정보 얻기
            self.parent.geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    print("주소 정보를 찾을 수 없습니다.")
                    return
                }
                
                let address = "\(placemark.country ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? "")"
                print("주소: \(address)")
                self.parent.address = address
            }
            
            // 버튼을 누르면 해당 위치를 공유하는 컨펌 창 띄우기
            let alertController = UIAlertController(title: "위치 공유", message: "위치를 공유하시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            let shareAction = UIAlertAction(title: "예", style: .default) { _ in
                // 공유 로직 추가
                let text = "위치: \(self.parent.address), \(coordinate.latitude), \(coordinate.longitude)"
                let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(shareAction)
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        func addTouchMarkerAtCoordinate(_ coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.parent.annotations = [annotation] // 바인딩된 속성을 변경하도록 수정
            mapView.addAnnotation(annotation)
        }
    }
}
