//
//  HomeUseCase.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol HomeUseCase {
    func requestAuthorization()
    func didUpdateLocation() -> Observable<Result<Location, Error>>
}

struct DefaultHomeUseCase: HomeUseCase {
    
    private let locationManager: LocationManager
    private let locationCache: Cache


    init(locationManager: LocationManager, locationCache: Cache) {
        self.locationManager = locationManager
        self.locationCache = locationCache
    }
    
    func requestAuthorization() {
        locationManager.requestAuthorization()
    }
    
    func didUpdateLocation() -> Observable<Result<Location, Error>> {
        locationManager.didUpdateLocation
    }
}
