//
//  HomeViewModel.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeViewModel: ViewModelType {
        
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let requestAuthorization: Driver<Void>
        let location: Driver<Location>
        let error: Driver<Error>
        let locations: Driver<[Location]>
    }
    
    private let useCase: HomeUseCase
    private let bag = DisposeBag()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        let trigger = input.trigger
        let locations: BehaviorRelay<[Location]> = .init(value: [])
        let currentLocation: PublishRelay<Location> = .init()
        let requestAuthorization = trigger.do(onNext: {
            useCase.requestAuthorization()
        })
        // Update location
        let didUpdateLocation = trigger.asObservable()
            .flatMapLatest(useCase.didUpdateLocation)
            .share()
        let locationUpdated = didUpdateLocation.onSuccess()
        let error = didUpdateLocation.onFailure()
        // Store location
        locationUpdated
            .flatMapLatest(useCase.store)
            .filter(\.isSuccess)
            .withLatestFrom(didUpdateLocation)
            .onSuccess()
            .bind(to: currentLocation)
            .disposed(by: bag)
        // FetchAll
        let fetchAllLocations = trigger
            .asObservable()
            .flatMapLatest(useCase.fetchAllLocations)
    
        fetchAllLocations
            .onSuccess()
            .bind(to: locations)
            .disposed(by: bag)
        
        return Output(
            requestAuthorization: requestAuthorization.asDriverOnEmpty(),
            location: locationUpdated.asDriverOnEmpty(),
            error: error.asDriverOnEmpty(),
            locations: locations.asDriverOnEmpty()
        )
    }
}
