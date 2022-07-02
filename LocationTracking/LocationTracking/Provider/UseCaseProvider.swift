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

    init(locationManager: LocationManager, locationCache: LocationCache) {
        self.locationManager = locationManager
        self.locationCache = locationCache
    }

    func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(locationManager: locationManager, locationCache: locationCache)
    }
}
