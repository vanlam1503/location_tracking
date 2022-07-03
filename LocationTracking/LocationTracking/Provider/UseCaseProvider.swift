//
//  UseCaseProvider.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

protocol UseCaseProvider {
    func makeHomeUseCase() -> HomeUseCase
}

struct DefaultUseCaseProvider: UseCaseProvider {

    private let locationManager: LocationManager
    private let locationCache: Cache
    private let storage: StorageManager

    init(locationManager: LocationManager, locationCache: LocationCache, storage: StorageManager) {
        self.locationManager = locationManager
        self.locationCache = locationCache
        self.storage = storage
    }

    func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(locationManager: locationManager, locationCache: locationCache, storage: storage)
    }
}
