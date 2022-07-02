//
//  LocationManager.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationManager {
    func requestAuthorization()
    var didUpdateLocation: Observable<Result<Location, Error>> { get }
}

final class DefaultLocationManager: NSObject, LocationManager {
    
    private let locationManager = CLLocationManager()
    private let _didUpdateLocation: PublishRelay<Result<Location, Error>> = .init()
    var didUpdateLocation: Observable<Result<Location, Error>> {
        _didUpdateLocation.asObservable()
    }
    
    override init() {
        super.init()
    }
    
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension DefaultLocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let location = Location(lat: lastLocation.coordinate.latitude, lng: lastLocation.coordinate.longitude)
        _didUpdateLocation.accept(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _didUpdateLocation.accept(.failure(error))
        
    }
}
