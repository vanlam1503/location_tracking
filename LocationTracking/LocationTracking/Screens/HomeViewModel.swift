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
        let requestAuthorization = trigger.do(onNext: {
            useCase.requestAuthorization()
        })
        let didUpdateLocation = trigger.asObservable()
            .flatMapLatest(useCase.didUpdateLocation)
            .share()
        let location = didUpdateLocation.onSuccess()
        let error = didUpdateLocation.onFailure()
        // FetchAll
        let locations = trigger
            .asObservable()
            .flatMapLatest(useCase.fetchAllLocations)
        
        return Output(
            requestAuthorization: requestAuthorization.asDriverOnEmpty(),
            location: location.asDriverOnEmpty(),
            error: error.asDriverOnEmpty(),
            locations: locations.asDriverOnEmpty()
        )
    }
}
