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
    func fetchAllLocations() -> Observable<Result<[Location], Error>>
    func store(location: Location) -> Observable<Result<Void, Error>>
}

struct DefaultHomeUseCase: HomeUseCase {
    
    private let locationManager: DefaultLocationManager
    private let storage: StorageManager

    init(locationManager: DefaultLocationManager, storage: StorageManager) {
        self.locationManager = locationManager
        self.storage = storage
    }
    
    func requestAuthorization() {
        locationManager.rx.requestAuthorization()
    }
    
    func didUpdateLocation() -> Observable<Result<Location, Error>> {
        locationManager.rx.didUpdateLocation.filter(\.isSuccess)
    }
    
    func store(location: Location) -> Observable<Result<Void, Error>> {
        return Observable.create { observer in
            do {
                try storage.save(location)
                observer.onNext(.success(()))
            } catch {
                observer.onNext(.failure(error))
            }
            return Disposables.create()
        }
    }

    
    func fetchAllLocations() -> Observable<Result<[Location], Error>> {
        return Observable.create { observer in
            do {
                let locations = try storage.fetchAllLocations()
                observer.onNext(.success(locations))
            } catch {
                observer.onNext(.failure(error))
            }
            return Disposables.create()
        }
    }
}
