//
//  LocationManager.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 4/26/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentAddress = "주소를 불러오는 중..."

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }

    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            currentAddress = "위치 서비스 접근 권한이 거부되었습니다."
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            currentAddress = "알 수 없는 오류가 발생했습니다."
        }
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchAddress(from: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentAddress = "위치를 찾을 수 없습니다."
    }

    private func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                self?.currentAddress = "주소 변환 오류: \(error.localizedDescription)"
                return
            }
            guard let placemark = placemarks?.first else {
                self?.currentAddress = "주소를 찾을 수 없습니다."
                return
            }
            self?.currentAddress = [
                placemark.country,
                placemark.administrativeArea,
                placemark.locality,
                placemark.subLocality,
                placemark.thoroughfare
//                placemark.subThoroughfare
            ].compactMap { $0 }.joined(separator: " ")
        }
    }
}



