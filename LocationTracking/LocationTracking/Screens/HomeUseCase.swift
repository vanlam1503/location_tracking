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
    func fetchAllLocations() -> Observable<[Location]>
}

struct DefaultHomeUseCase: HomeUseCase {
    
    private let locationManager: LocationManager
    private let locationCache: Cache
    private let storage: StorageManager

    init(locationManager: LocationManager, locationCache: Cache, storage: StorageManager) {
        self.locationManager = locationManager
        self.locationCache = locationCache
        self.storage = storage
    }
    
    func requestAuthorization() {
        locationManager.requestAuthorization()
    }
    
    func didUpdateLocation() -> Observable<Result<Location, Error>> {
        locationManager.didUpdateLocation
            .do(onNext: { result in
                switch result {
                case .success(let location):
                    storage.save(location)
                case .failure: break
                }
            })
    }
    
    func fetchAllLocations() -> Observable<[Location]> {
        return Observable.create { observer in
            do {
                let locations = try storage.fetchAllLocations()
                observer.onNext(locations)
            } catch {
                observer.onNext([])
            }
            return Disposables.create()
        }
    }
}
