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

    private let locationManager: DefaultLocationManager
    private let storage: StorageManager

    init(locationManager: DefaultLocationManager, storage: StorageManager) {
        self.locationManager = locationManager
        self.storage = storage
    }

    func makeHomeUseCase() -> HomeUseCase {
        DefaultHomeUseCase(locationManager: locationManager, storage: storage)
    }
}
