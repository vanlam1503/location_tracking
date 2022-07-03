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

final class DefaultLocationManager: NSObject {

    static let shared = DefaultLocationManager()
    private let locationManager = CLLocationManager()
    fileprivate let didUpdateLocation: PublishRelay<Result<Location, Error>> = .init()
    
    override private init() {
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
        let location = Location(
            lat: lastLocation.coordinate.latitude,
            lng: lastLocation.coordinate.longitude,
            description: lastLocation.description)
        didUpdateLocation.accept(.success(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didUpdateLocation.accept(.failure(error))
        
    }
}

extension Reactive where Base: DefaultLocationManager {
    
    func requestAuthorization() {
        base.requestAuthorization()
    }
    
    var didUpdateLocation: Observable<Result<Location, Error>> {
        base.didUpdateLocation.asObservable()
    }
}
